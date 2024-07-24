// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.19;

import { IAccessControlManager } from "./interfaces/IAccessControlManager.sol";


/// @title AccessControlManager
/// @author Angle Labs, Inc.
contract AccessControlManager is IAccessControlManager {
    constructor() {

    }

    /// @notice Checks whether an address is governor of the Angle Protocol or not
    /// @param admin Address to check
    /// @return Whether the address has the `GOVERNOR_ROLE` or not
    function isGovernor(address admin) external pure returns (bool) {
        return admin == 0xb8A1dF43c1c88b13937C0c5CEBbAd15830cAeC03;
    }

    /// @notice Checks whether an address is governor or a guardian of the Angle Protocol or not
    /// @param admin Address to check
    /// @return Whether the address has the `GUARDIAN_ROLE` or not
    /// @dev Governance should make sure when adding a governor to also give this governor the guardian
    /// role by calling the `addGovernor` function
    function isGovernorOrGuardian(address admin) external pure returns (bool) {
        return admin == 0xb8A1dF43c1c88b13937C0c5CEBbAd15830cAeC03;
    }

}
