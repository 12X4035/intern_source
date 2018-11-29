// Empty JS for your own code to be here
var Base64 = {_keyStr:"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=",
encode:function(e){var t="";var n,r,i,s,o,u,a;var f=0;e=Base64._utf8_encode(e);while(f<e.length){n=e.charCodeAt(f++);r=e.charCodeAt(f++);i=e.charCodeAt(f++);s=n>>2;o=(n&3)<<4|r>>4;u=(r&15)<<2|i>>6;a=i&63;if(isNaN(r)){u=a=64}else if(isNaN(i)){a=64}t=t+this._keyStr.charAt(s)+this._keyStr.charAt(o)+this._keyStr.charAt(u)+this._keyStr.charAt(a)}return t},
decode:function(e){var t="";var n,r,i;var s,o,u,a;var f=0;e=e.replace(/[^A-Za-z0-9+/=]/g,"");while(f<e.length){s=this._keyStr.indexOf(e.charAt(f++));o=this._keyStr.indexOf(e.charAt(f++));u=this._keyStr.indexOf(e.charAt(f++));a=this._keyStr.indexOf(e.charAt(f++));n=s<<2|o>>4;r=(o&15)<<4|u>>2;i=(u&3)<<6|a;t=t+String.fromCharCode(n);if(u!=64){t=t+String.fromCharCode(r)}if(a!=64){t=t+String.fromCharCode(i)}}t=Base64._utf8_decode(t);return t},
_utf8_encode:function(e){e=e.replace(/rn/g,"n");var t="";for(var n=0;n<e.length;n++){var r=e.charCodeAt(n);if(r<128){t+=String.fromCharCode(r)}else if(r>127&&r<2048){t+=String.fromCharCode(r>>6|192);t+=String.fromCharCode(r&63|128)}else{t+=String.fromCharCode(r>>12|224);t+=String.fromCharCode(r>>6&63|128);t+=String.fromCharCode(r&63|128)}}return t},
_utf8_decode:function(e){var t="";var n=0;var r=c1=c2=0;while(n<e.length){r=e.charCodeAt(n);if(r<128){t+=String.fromCharCode(r);n++}else if(r>191&&r<224){c2=e.charCodeAt(n+1);t+=String.fromCharCode((r&31)<<6|c2&63);n+=2}else{c2=e.charCodeAt(n+1);c3=e.charCodeAt(n+2);t+=String.fromCharCode((r&15)<<12|(c2&63)<<6|c3&63);n+=3}}return t}}

var yourKey = Base64.encode($('#yourEmail').val());

$('#send_token_popup').on('show.bs.modal', function(e) {
    $('#send_token_popup').find('.alert').hide();
    $('#accountPassword').val('');
    $('#giveTokenAmount').val(1);
    $(this).find('#sendTokenBtn').button('reset');
    $('#send_token_popup').find('#toAddress').val($(e.relatedTarget).data('address'));
    $('#send_token_popup').find('#fromAddress').val($(e.relatedTarget).data('address'));
 });

$('#create_account_popup').on('show.bs.modal', function(e) {
    $('#create_account_popup').find('.alert').hide();
    $('#accountPassword').val('');
    $(this).find('#createAccountBtn').button('reset');
 });

$('#create_pool_popup').on('show.bs.modal', function(e) {
    $('#create_pool_popup').find('.alert').hide();
    $('#accountPassword').val('');
    $(this).find('#createPoolBtn').button('reset');
    $('#create_pool_popup').find('#poolAddress').val($(e.relatedTarget).data('address'));
 });


$('#sendTokenBtn').click(function(e) {
    $('#send_token_popup').find('.alert').hide();
    var showError = function(mess) {
        mess = (mess) ? mess : 'Oh snap! Send token failed.';
        let msgBox = $('#send_token_popup').find('.alert-danger');
        msgBox.find('span').text(mess);
        msgBox.show();
        $this.button('reset');
    }

    var $this = $(this);
    if ($this.hasClass('disabled')) return false;
    if (!$('#accountPassword').val()) { alert('Input password'); return false; }
    $this.button('loading');

    let account = LOCAL_STORAGE.getAccount(yourKey);
    if (!account) { return showError('Oh snap! The wrong account'); }

    //from Account = admin account
 
    let fromAddress = addHexPrefix($('#send_token_popup').find('#fromAddress').val());
    if (!fromAddress) { return showError('Oh snap! This post cannot send token'); }   

    let toAddress = addHexPrefix($('#send_token_popup').find('#toAddress').val());
    if (!toAddress) { return showError('Oh snap! This post cannot receive token'); }

    let amount = Number($('#giveTokenAmount').val());
    let accountPassword = $.trim($('#accountPassword').val());

//sendToken
    sendToken(account, accountPassword, fromAddress, toAddress, amount).then((res) => {
        getCurrentBalance(account.getAddress()).then((balance) => {
            $('#currentPersonalToken').html('Token: ' + balance + ' HDO');
            $('#create_pool_popup').find('.alert-success').show();
            $this.button('reset');
        });
    }).catch((err) => { showError(); });
});


$('#createAccountBtn').click(function(e) {
    let $this = $(this);
    if ($this.hasClass('disabled')) return false;
    if (!$('#accountPassword').val()) { alert('Input password'); return false; }
    $this.button('loading'); 

    let accountPassword = $.trim($('#accountPassword').val());
    createNewAccount(BASE_URL, accountPassword).then((_account) => {
        LOCAL_STORAGE.setAccount(_account, yourKey);
        $('#create-account-form').find('#personaladdress').val(formatAddr(_account.getAddress()));
        $('#create-account-form').submit();
    }).catch((err) => {
        let msgBox = $('#create_account_popup').find('.alert');
        msgBox.find('span').text('Oh snap! Create account failed');
        msgBox.show();
        $this.button('reset');
    });
});

$('#createPoolBtn').click(function(e) {
    let $this = $(this);
    if ($this.hasClass('disabled')) return false;
    if (!$('#accountPassword').val()) { alert('Input password'); return false; }
    $this.button('loading'); 
    
    let account = LOCAL_STORAGE.getAccount(yourKey);
    if (!account) { return showError('Oh snap! The wrong account'); }
    
    let accountPassword = $.trim($('#accountPassword').val());
     
    let poolAddress = '0x'+$('#pooladdress').val();

    CreatePool(account, accountPassword, poolAddress).then((pooladdress) => {   
	console.log(poolAddress);
	LOCAL_STORAGE.setPoolAccount(poolAddress, 'pool');

        $('#create-pool-form').find('#pooladdress').val();
        $('#create-pool-form').submit();

    }).catch((err) => {
        let msgBox = $('#create_account_popup').find('.alert');
        msgBox.find('span').text('Oh snap! Create pool failed');
        msgBox.show();
        $this.button('reset');
    });
});


function getTransactionReceiptLoop(contract, txHash, cb) {
    contract.getTransactionReceipt(txHash, function(err, res) {
        if (err) cb(err);
        else if (res) cb(null, res);
        else setTimeout(function() { getTransactionReceiptLoop(contract, txHash, cb); }, 5000);
    });
}

function getCurrentBalance(address) {
      return new Promise(function(resolve, reject) {
        let proxyAccount = ethClient.Account.deserialize(SERIALIZED_PROXY_ACCOUNT);
        let contract = new ethClient.AltExecCnsContract(proxyAccount, CNS_ADDRESS);
        return contract.call(
            PROXY_PASSWORD,
            CONTRACT_NAME,
            'balanceOf',
            [TOKEN_ADDRESS , address],
            PROXYCONTROLLER_ABI,
            function(err, res) {
                if (err) { return reject(err); }
                return resolve(res[0].toString());
        });
    });  
}

function sendToken(account, password, fromAddress, toAddress, amount) {
    // TODO
	return new Promise(function (resolve, reject) {
         if (!account) return reject();
         var contract = new ethClient.AltExecCnsContract(account, CNS_ADDRESS);
         // nonce の取得
         contract.call(password,
         CONTRACT_NAME,
         'getNonce',
         [TOKEN_ADDRESS,
         account.getAddress()],
         PROXYCONTROLLER_ABI,
         function(err, res) {
             if (err) { return reject(err); }
             // Bignumber なので、String へ変更
             let nonce = res[0].toString();
             // TokenSample でチェックするためのサイン
             account.sign(password, ethClient.utils.hashBySolidityType(
                 ['address', 'bytes32', 'address', 'address', 'uint', 'uint'],
                 [TOKEN_ADDRESS, 'transferWithSign', fromAddress, toAddress, amount, nonce]
             ), function(_err, sign) {
                 if (_err) { return reject(_err); }
                 // トランザクションを投げる
                 contract.sendTransaction(
                     password,
                     CONTRACT_NAME,
                     'transferWithSign',
                     [TOKEN_ADDRESS, fromAddress, toAddress, amount, nonce, sign],
                     PROXYCONTROLLER_ABI,
                     function(__err, __res) {
                         if (__err) { return reject(__err); }
                         var txHash = __res;
                         // トランザクションがブロックに入るのを待つ
                         return getTransactionReceiptLoop(
                             contract,
                             txHash,
                             function(err, receipt) {
                                 if (err) return reject(err);
                                 return resolve(__res);
                         });
                 });
             });
         });
     });

}

//【createNewAccount】
//promise 非同期処理
/// web/js/eth-client.js
function createNewAccount(_baseUrl, _password) {
    return new Promise(function(resolve, reject) {
        return ethClient.Account.create(_baseUrl, _password, function(err, _account) {
            if (err) reject(err);
            else { resolve(_account); }
        })
    })
}


function CreatePool(account, password, poolAddress) {
    // TODO
	return new Promise(function (resolve, reject) {
         if (!account) return reject();
         var contract = new ethClient.AltExecCnsContract(account, CNS_ADDRESS);
         // nonce の取得
         contract.call(password,
         CONTRACT_NAME,
         'getNonce',
         [TOKEN_ADDRESS,
         account.getAddress()],
         PROXYCONTROLLER_ABI,
         function(err, res) {
             if (err) { return reject(err); }
             // Bignumber なので、String へ変更
             let nonce = res[0].toString();
             // TokenSample でチェックするためのサイン
             account.sign(password, ethClient.utils.hashBySolidityType(
                 ['address', 'bytes32', 'address', 'uint'],
                 [TOKEN_ADDRESS, 'CreatePool', poolAddress, nonce]
             ), function(_err, sign) {
                 if (_err) { return reject(_err); }
                 // トランザクションを投げる
                 contract.sendTransaction(
                     password,
                     CONTRACT_NAME,
                     'CreatePool',
                     [TOKEN_ADDRESS, poolAddress, nonce, sign],
                     PROXYCONTROLLER_ABI,
                     function(__err, __res) {
                         if (__err) { return reject(__err); }
                         var txHash = __res;
                         // トランザクションがブロックに入るのを待つ
                         return getTransactionReceiptLoop(
                             contract,
                             txHash,
                             function(err, receipt) {
                                 if (err) return reject(err);
                                 return resolve(__res);
                         });
                 });
             });
         });
     });

}

function AddMember(account, password, poolAddress, newAddress) {
    // TODO
	return new Promise(function (resolve, reject) {
         if (!account) return reject();
         var contract = new ethClient.AltExecCnsContract(account, CNS_ADDRESS);
         // nonce の取得
         contract.call(password,
         CONTRACT_NAME,
         'getNonce',
         [TOKEN_ADDRESS,
         account.getAddress()],
         PROXYCONTROLLER_ABI,
         function(err, res) {
             if (err) { return reject(err); }
             // Bignumber なので、String へ変更
             let nonce = res[0].toString();
             // TokenSample でチェックするためのサイン
             account.sign(password, ethClient.utils.hashBySolidityType(
                 ['address', 'bytes32', 'address', 'address', 'uint'],
                 [TOKEN_ADDRESS, 'AddMember', poolAddress, newAddress, nonce]
             ), function(_err, sign) {
                 if (_err) { return reject(_err); }
                 // トランザクションを投げる
                 contract.sendTransaction(
                     password,
                     CONTRACT_NAME,
                     'AddMember',
                     [TOKEN_ADDRESS, poolAddress, newAddress, nonce, sign],
                     PROXYCONTROLLER_ABI,
                     function(__err, __res) {
                         if (__err) { return reject(__err); }
                         var txHash = __res;
                         // トランザクションがブロックに入るのを待つ
                         return getTransactionReceiptLoop(
                             contract,
                             txHash,
                             function(err, receipt) {
                                 if (err) return reject(err);
                                 return resolve(__res);
                         });
                 });
             });
         });
     });

}

function formatAddr(addr){
    addr = addr.trim();
    if (addr.length == 42) { return addr.substring(2, 42); }
    return addr;
};

function addHexPrefix(str) {
    if (typeof str !== 'string') { return str; }
    return isHexPrefixed(str) ? str : '0x' + str;
}

function isHexPrefixed(str) {
    return str.slice(0, 2) === '0x';
};

function showCurrentBalance() {
    let yourAccount = LOCAL_STORAGE.getAccount(yourKey);
    if (yourAccount && $('#yourAddress').val()) {
        getCurrentBalance(yourAccount.getAddress()).then((balance) => {
            $('#currentPersonalToken').html('Token: ' + balance + ' HDO');
        })
    }
}

function showCurrentPoolBalance() {
    let yourAccount = LOCAL_STORAGE.getPoolAccount('pool');
    if (yourAccount && $('#yourPoolAddress').val()) {
        getCurrentBalance('0x'+yourAccount).then((balance) => {
            $('#currentPoolToken').html('Token: ' + balance + ' HDO');
        })
    }
}

$(function() {
    showCurrentBalance();
    showCurrentPoolBalance();
});
