# bitcore-wallet-client-ltz

The *LitecoinZ fork* client library for [bitcore-wallet-service-ltz] (https://github.com/LitecoinZ-Community/bitcore-wallet-service-ltz). 

## Description

This package communicates with BWS [Bitcore wallet service LTZ](https://github.com/LitecoinZ-Community/bitcore-wallet-service-ltz) using the REST API. All REST endpoints are wrapped as simple async methods. All relevant responses from BWS are checked independently by the peers, thus the importance of using this library when talking to a third party BWS instance.

See [Bitcore-wallet] (https://github.com/bitpay/bitcore-wallet) for a simple CLI wallet implementation that relays on BWS and uses bitcore-wallet-client-ltz.

## Get Started

You can start using bitcore-wallet-client-ltz in any of these two ways:

* via [Bower](http://bower.io/): by running `bower install bitcore-wallet-client-ltz` from your console
* or via [NPM](https://www.npmjs.com/package/bitcore-wallet-client-ltz): by running `npm install bitcore-wallet-client-ltz` from your console.

## Example

Start your own local [Bitcore wallet service LTZ](https://github.com/LitecoinZ-Community/bitcore-wallet-service-ltz) instance. In this example we assume you have `bitcore-wallet-service-ltz` running on your `localhost:3232`.

Then create two files `irene.js` and `tomas.js` with the content below:

**irene.js**

``` javascript
var Client = require('bitcore-wallet-client-ltz');


var fs = require('fs');
var BWS_INSTANCE_URL = 'https://bws.litecoinz.org/bws/api'

var client = new Client({
  baseUrl: BWS_INSTANCE_URL,
  verbose: false,
});

client.createWallet("My Wallet", "Irene", 2, 2, {network: 'testnet'}, function(err, secret) {
  if (err) {
    console.log('error: ',err); 
    return
  };
  // Handle err
  console.log('Wallet Created. Share this secret with your copayers: ' + secret);
  fs.writeFileSync('irene.dat', client.export());
});
```

**tomas.js**

``` javascript

var Client = require('bitcore-wallet-client-ltz');


var fs = require('fs');
var BWS_INSTANCE_URL = 'https://bws.litecoinz.org/bws/api'

var secret = process.argv[2];
if (!secret) {
  console.log('./tomas.js <Secret>')

  process.exit(0);
}

var client = new Client({
  baseUrl: BWS_INSTANCE_URL,
  verbose: false,
});

client.joinWallet(secret, "Tomas", {}, function(err, wallet) {
  if (err) {
    console.log('error: ', err);
    return
  };

  console.log('Joined ' + wallet.name + '!');
  fs.writeFileSync('tomas.dat', client.export());


  client.openWallet(function(err, ret) {
    if (err) {
      console.log('error: ', err);
      return
    };
    console.log('\n\n** Wallet Info', ret); //TODO

    console.log('\n\nCreating first address:', ret); //TODO
    if (ret.wallet.status == 'complete') {
      client.createAddress({}, function(err,addr){
        if (err) {
          console.log('error: ', err);
          return;
        };

        console.log('\nReturn:', addr)
      });
    }
  });
});
```

Install `bitcore-wallet-client-ltz` before start:

```
npm i bitcore-wallet-client-ltz
```

Create a new wallet with the first script:

```
$ node irene.js
info Generating new keys 
 Wallet Created. Share this secret with your copayers: JbTDjtUkvWS4c3mgAtJf4zKyRGzdQzZacfx2S7gRqPLcbeAWaSDEnazFJF6mKbzBvY1ZRwZCbvT
```

Join to this wallet with generated secret:

```
$ node tomas.js JbTDjtUkvWS4c3mgAtJf4zKyRGzdQzZacfx2S7gRqPLcbeAWaSDEnazFJF6mKbzBvY1ZRwZCbvT
Joined My Wallet!

Wallet Info: [...]

Creating first address:

Return: [...]

```

Note that the scripts created two files named `irene.dat` and `tomas.dat`. With these files you can get status, generate addresses, create proposals, sign transactions, etc.


