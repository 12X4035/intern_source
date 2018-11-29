const ethClient = require('eth-client');
const config = require('./config');
const zcomConfig = require('./zcom-vars-compiled');

const MAX_FIRST_TOKEN = 100;
const CONTRACT_NAME = 'ProxyController';
const BASE_URL = 'https://api.blockchain.z.com';



// If the action is rejected this func. returns the error.
// If resolved, it returns the receipt.
function sendToken(account, password, toAddress, amount) {
    return new Promise(function (resolve, reject) {
	//account = true→ reject .catch((err))
	//null, undefined, 0, ('') then, return false.
	// if (account !== true)
        if (!account) return reject();

	// send request	to AltExecCnsAPI
        var contract = new ethClient.AltExecCnsContract(account, zcomConfig.CNS_ADDRESS);

	//call the method of Contract, then get the result(call-back)
	//call(password, contractname, functionname, params, abi, callback)
        contract.call(password, CONTRACT_NAME, 'getNonce',[ config.tokenAddress , account.getAddress()], zcomConfig.PROXYCONTROLLER_ABI ,function(err, res) {
	    // if →reject 
            if (err) { return reject(err); }
	    // get(create) nonce
    	    var nonce = res[0].toString();

	    // sign to hash
	    // sign(password, hash, callback)
            account.sign(password, ethClient.utils.hashBySolidityType(['address', 'bytes32', 'address', 'address', 'uint', 'uint'],
                [config.tokenAddress, 'transferWithSign', account.getAddress(), toAddress, amount, nonce]), function(_err, sign) {
                if (_err) { return reject(_err); }
			
		
		    //sendTransaction(password, contractName, functionName, params, abi, callback)
                    contract.sendTransaction(password, CONTRACT_NAME, 'transferWithSign', [config.tokenAddress, account.getAddress(), toAddress, amount, nonce, sign], zcomConfig.PROXYCONTROLLER_ABI, function(__err, __res) {
                        if (__err) { return reject(__err); }	

			// get the detail of the transaction
                        var getTransactionReceipt = function(txHash, cb) {
                            contract.getTransactionReceipt(txHash, function(err, res) {
                                if (err) cb(err);
                                else if (res) cb(null, res);
                                else setTimeout(function() { getTransactionReceipt(txHash, cb); }, 5000);
                            });
                        }
                        var txHash = __res;
                        return getTransactionReceipt(txHash, function(err, receipt) {
                            if (err) return reject(err);
                            return resolve(receipt);
                        });
                    });
            });
        });
    });
}

function addHexPrefix(str) {
    if (typeof str !== 'string') { return str; }
    return isHexPrefixed(str) ? str : '0x' + str;
}

function isHexPrefixed(str) { return str.slice(0, 2) === '0x'; };

var userAddress = addHexPrefix(process.argv[2]);

var adminAccount = ethClient.Account.deserialize(config.admin.account);


sendToken(adminAccount, config.admin.password , userAddress, MAX_FIRST_TOKEN).then((res) => {
    console.log(res);
}).catch((err) => {
    console.log(err)
})
