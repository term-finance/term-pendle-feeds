// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.12;

import { UNIT, UD60x18, ud } from "prb/math/UD60x18.sol";
import "pendle/interfaces/IPMarket.sol";
import { PendlePYOracleLib } from "pendle/oracles/PendlePYOracleLib.sol";
import "../utils/Errors.sol";

/// @title BaseOraclePTPendle
/// @author Angle Labs, Inc.
/// @notice Base oracle implementation for PT tokens on Pendle
abstract contract BaseOraclePTPendle {
    uint256 public constant BASE_18 = 1 ether;
    uint256 public constant YEAR = 365 days;
    // @notice The maximum implied rate for the underlying asset, if set well it allows to have a lower bound on the PT token price
    uint256 public maxImpliedRate;
    // @notice The duration of the TWAP used to calculate the PT price
    uint32 public twapDuration;

    /*//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                        EVENTS                                                      
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////*/

    event MaxImpliedRateUpdated(uint256 _maxImpliedRate);
    event TwapPTDurationUpdated(uint256 _twapDuration);

    constructor(uint256 _maxImpliedRate, uint32 _twapDuration) {
        if (_twapDuration < 15 minutes) revert TwapDurationTooLow();
        maxImpliedRate = _maxImpliedRate;
        twapDuration = _twapDuration;
    }

    function _getQuoteAmount() internal view virtual returns (uint256) {
        (uint256 pendlePrice, uint256 index) = _pendlePTPrice(IPMarket(market()), twapDuration);
        uint256 economicalLowerBound = (_economicalPTLowerBoundPrice() * BASE_18) / index;
        uint256 minPrice = economicalLowerBound < pendlePrice ? pendlePrice : economicalLowerBound;
        uint256 quote = (_detectHackRatio() * minPrice) / BASE_18;
        return quote;
    }


    /*//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                       INTERNAL                                                     
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////*/

    function _economicalPTLowerBoundPrice() internal view returns (uint256) {
        uint256 exp = block.timestamp > maturity() ? 0 : maturity() - block.timestamp;
        if (exp == 0) return BASE_18;

        UD60x18 denominator = UNIT.add(ud(maxImpliedRate)).pow(ud(exp).div(ud(YEAR)));
        uint256 lowerBound = UNIT.div(denominator).unwrap();
        return lowerBound;
    }

    /// @dev Depending on the market you should use
    ///       - getPtToSy() should be used if the underlying token is tradable,
    ///       - getPtToAsset() if not
    /// @dev https://docs.pendle.finance/Developers/Contracts/StandardizedYield#asset-of-sy--assetinfo-function
    function _pendlePTPrice(IPMarket _market, uint32 _twapDuration) internal view virtual returns (uint256, uint256) {
        return (PendlePYOracleLib.getPtToAssetRate(_market, _twapDuration), BASE_18);
    }

    function _detectHackRatio() internal view returns (uint256) {
        uint256 assetBalanceSY = IERC20(asset()).balanceOf(sy());
        uint256 totalSupplySY = IERC20(sy()).totalSupply();
        return assetBalanceSY > totalSupplySY ? BASE_18 : (assetBalanceSY * BASE_18) / totalSupplySY;
    }

    /*//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                       OVERRIDES                                                    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////*/

    function asset() public pure virtual returns (address);

    function sy() public pure virtual returns (address);

    function maturity() public pure virtual returns (uint256);

    function market() public pure virtual returns (address);
}
