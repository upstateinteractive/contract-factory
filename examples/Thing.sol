pragma solidity ^0.5.0;

import '@openzeppelin/upgrades/contracts/Initializable.sol';
import '@openzeppelin/contracts-ethereum-package/contracts/ownership/Ownable.sol';
import "openzeppelin-solidity/contracts/math/SafeMath.sol";
import "./contracts/AdminFactory.sol";


contract Thing is Initializable, Ownable {
    using SafeMath for uint256;

    event ThingEvent(address sender, string name, uint256 value);

      /******************
    INTERNAL ACCOUNTING
    ******************/
    string public name;
    uint256 public value;

    /**
    * @dev Logic contract that proxyies point to
    * @param _name name
    * @param _value value
    * @param _owner The address of the thing owner
    */
    function initialize(string memory _name, uint256 _value, address _owner) public {
        Ownable.initialize(_owner);
        name = _name;
        value = _value;
    }

    /**
    * @dev Allows owner to transfer ownership of proxy
    * @param _newOwner The address to transfer ownership to
    */
    function transferOwnership(address _newOwner, address _factory) public onlyOwner {
        super.transferOwnership(_newOwner);
        AdminFactory adminFactory = AdminFactory(_factory);
        adminFactory.changeProxyOwner(msg.sender, _newOwner);
    }

    function doSomething() public {
        emit ThingEvent(address(this), name, value);
    }
}
