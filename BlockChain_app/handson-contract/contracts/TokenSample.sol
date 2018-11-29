pragma solidity ^0.4.17;

import "zeppelin-solidity/contracts/token/ERC20/StandardToken.sol";

contract TokenSample is StandardToken {
    bytes32 public symbol = "HDO";
    bytes32 public name = "Token HDO";

    // nonce for each account
    mapping(address => uint) nonces;

    // Constructor
    constructor(uint _supplyVolume) public {
        balances[msg.sender] = _supplyVolume;
        totalSupply_  = _supplyVolume;
    }

    function nonceOf(address _owner) public constant returns (uint nonce) {
        return nonces[_owner];
    }
/*
    function transferWithSign(address _to, uint _amount, uint _nonce, bytes _sign) public returns (bool success) {
        bytes32 hash = calcEnvHash('transferWithSign');
        hash = keccak256(hash, _to);
        hash = keccak256(hash, _amount);
        hash = keccak256(hash, _nonce);
        address from = recoverAddress(hash, _sign);

        if (_nonce != nonces[from]) return false;
        nonces[from]++;

        // TODO
	require(_to !=address(0));
	require(_amount <= balances[from]);

	balances[from] = balances[from].sub(_amount);
	balances[_to] = balances[_to].add(_amount);
	emit Transfer(from, _to, _amount);
        return true;
    }
*/
    function calcEnvHash(bytes32 _functionName) public constant returns (bytes32 hash) {
        hash = keccak256(this);
        hash = keccak256(hash, _functionName);
    }

    function recoverAddress(bytes32 _hash, bytes _sign) public pure returns (address recoverdAddr) {
        bytes32 r;
        bytes32 s;
        uint8 v;

        require(_sign.length == 65);

        assembly {
            r := mload(add(_sign, 32))
            s := mload(add(_sign, 64))
            v := byte(0, mload(add(_sign, 96)))
        }

        if (v < 27) v += 27;
        require(v == 27 || v == 28);

        recoverdAddr = ecrecover(_hash, v, r, s);
        require(recoverdAddr != 0);
    }

    // write from here

    struct Pool {
        address owner;
        mapping( address => bool) members;
    }

    mapping (address => Pool) pools;

    //Create Pool
    function CreatePool(address _pool, uint _nonce, bytes _sign) public returns (bool success){
	bytes32 hash = calcEnvHash('CreatePool');
	hash = keccak256(hash, _pool);
	hash = keccak256(hash, _nonce);
	address from = recoverAddress(hash, _sign);

	if(_nonce != nonces[from]) return false;
	nonces[from]++;

        pools[_pool].owner = from;
        pools[_pool].members[from] =  true;

        return true;
    }   
    
    //AddMember 
    function AddMember(address _pool, address _new, uint _nonce, bytes  _sign) public returns (bool success) {
        bytes32 hash = calcEnvHash('AddMember');
        hash = keccak256(hash, _pool);
        hash = keccak256(hash, _new);
        hash = keccak256(hash, _nonce);
	address from = recoverAddress(hash, _sign);
	
        if(_nonce != nonces[from]) return false;
        nonces[from]++;

        require(pools[_pool].owner == from);
        pools[_pool].members[_new] =  true;

        return true;
    } 

    //new transferWithSign 
    function transferWithSign(address _from, address _to, uint _amount, uint _nonce, bytes _sign) public returns (bool success) {
        bytes32 hash = calcEnvHash('transferWithSign');
        hash = keccak256(hash, _from);
        hash = keccak256(hash, _to);
        hash = keccak256(hash, _amount);
        hash = keccak256(hash, _nonce);
        address from = recoverAddress(hash, _sign);

        if (_nonce != nonces[from]) return false;
        nonces[from]++;

        // TODO
        
        require(pools[_from].members[from] == true || _from == from);
	require(_to !=address(0));
	require(_amount <= balances[_from]);

	balances[_from] = balances[_from].sub(_amount);
	balances[_to] = balances[_to].add(_amount);

	emit Transfer(from, _to, _amount);
        return true;
    }
	
}
