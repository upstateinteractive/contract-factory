pragma solidity ^0.5.0;

import "@openzeppelin/upgrades/contracts/upgradeability/Proxy.sol";
import "@openzeppelin/upgrades/contracts/utils/Address.sol";

/**
 * @title ProxyContract
 * @dev This contract implements a proxy
 */

contract ProxyContract is Proxy {

  /**
   * @dev Storage slot with the address of the current implementation.
   * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
   * validated in the constructor.
   */
  bytes32 internal constant IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;

    /**
    * @dev Contract initializer.
    * @param _logic Address of the initial implementation.
    * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
    * It should include the signature and the parameters of the function to be called, as described in
    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
    */
    function initialize(address _logic, bytes memory _data) public payable {
        require(_implementation() == address(0));
        assert(IMPLEMENTATION_SLOT == bytes32(uint256(keccak256('eip1967.proxy.implementation')) - 1));
        _setImplementation(_logic);
        if(_data.length > 0) {
        (bool success,) = _logic.delegatecall(_data);
        require(success);
        }
    }

    /**
    * @dev Returns the current implementation.
    * @return Address of the current implementation
    */
    function _implementation() internal view returns (address impl) {
        bytes32 slot = IMPLEMENTATION_SLOT;
        assembly {
        impl := sload(slot)
        }
    }

    /**
    * @dev Sets the implementation address of the proxy.
    * @param newImplementation Address of the new implementation.
    */
    function _setImplementation(address newImplementation) internal {
        require(OpenZeppelinUpgradesAddress.isContract(newImplementation), "Cannot set a proxy implementation to a non-contract address");

        bytes32 slot = IMPLEMENTATION_SLOT;

        assembly {
        sstore(slot, newImplementation)
        }
    }
}
