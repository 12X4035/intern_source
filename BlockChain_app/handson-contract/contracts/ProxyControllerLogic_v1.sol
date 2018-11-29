pragma solidity ^0.4.17;

import 'zcom-contracts/contracts/VersionLogic.sol';
import './TokenSample.sol';

contract ProxyControllerLogic_v1 is VersionLogic {

    constructor(ContractNameService _cns) VersionLogic (_cns, "ProxyController") public {}

    function getSymbol(address _tokenAddress) public constant returns (bytes32 symbol) {
        return TokenSample(_tokenAddress).symbol();
    }

    function getName(address _tokenAddress) public constant returns (bytes32 name) {
        return TokenSample(_tokenAddress).name();
    }

    function getTotalSupply(address _tokenAddress) public constant returns (uint totalSupply) {
        return TokenSample(_tokenAddress).totalSupply();
    }

    function getNonce(address _tokenAddress, address _addr) public constant returns (uint nonce) {
        return TokenSample(_tokenAddress).nonceOf(_addr);
    }

    function balanceOf(address _tokenAddress, address _addr) public constant returns (uint balance) {
        return TokenSample(_tokenAddress).balanceOf(_addr);
    }

    function transferWithSign(address _tokenAddress, address _from, address _to, uint _amount, uint _nonce, bytes _sign) public onlyByVersionContractOrLogic {
        // TODO
	require(TokenSample(_tokenAddress).transferWithSign(_from, _to, _amount, _nonce, _sign));
    }

    function CreatePool(address _tokenAddress, address _pool, uint _nonce, bytes _sign) public onlyByVersionContractOrLogic {
        // TODO
	require(TokenSample(_tokenAddress).CreatePool(_pool, _nonce, _sign));
    }

    function AddMember(address _tokenAddress, address _pool, address _new, uint _nonce, bytes _sign) public onlyByVersionContractOrLogic {
        // TODO
	require(TokenSample(_tokenAddress).AddMember(_pool, _new, _nonce, _sign));
    }
}
