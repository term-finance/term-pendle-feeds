// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.12;

import "./BaseFeedPTPendle.sol"; // Import the BaseFeedPTPendle contract

contract TermSusdePTPendleFeed is BaseFeedPTPendle {
    string public constant description = "PT-weETH/ETH Oracle";

    AggregatorV3Interface public usdePriceFeed;
    constructor(
        uint256 _maxImpliedRate,
        uint32 _twapDuration,
        address usdePriceFeed_
    ) BaseFeedPTPendle(_maxImpliedRate, _twapDuration) {
        usdePriceFeed = AggregatorV3Interface(usdePriceFeed_);
    }

    function asset() public pure override returns (address) {
        return 0x9D39A5DE30e57443BfF2A8307A4256c8797A3497;
    }

    function sy() public pure override returns (address) {
        return 0x1605A410c8480A18A3e958fAFF3b6D2834fbae22 ;
    }

    function maturity() public pure override returns (uint256) {
        return 1729728000;
    }

    function market() public pure override returns (address) {
        return 0xd1D7D99764f8a52Aff007b7831cc02748b2013b5;
    }

    /// @inheritdoc AggregatorV3Interface
    function getRoundData(
        uint80 _roundId
    )
        external
        view
        override
        returns (uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound)
    {
        
        (, int256 answer, , uint256 updatedAt, ) = usdePriceFeed.getRoundData(_roundId);
        int256 usdPrice = int256(_getQuoteAmount()) * answer * 10 ** 10  / 10 ** 18;
        
        return (0, usdPrice , 0, updatedAt, 0);
    }

    /// @inheritdoc AggregatorV3Interface
    function latestRoundData()
        external
        view
        override
        returns (uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound)
    {
        (, int256 answer, , uint256 updatedAt, ) = usdePriceFeed.latestRoundData();
        int256 usdPrice = int256(_getQuoteAmount()) * answer * 10 ** 10 / 10 ** 18;
        

        return (0, usdPrice, 0, updatedAt, 0);
    }
}