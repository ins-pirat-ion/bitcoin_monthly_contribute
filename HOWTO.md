HOWTO install and use bitcoin_monthly_contribute suite
======================================================

Prerequisities
--------------

* installed `bitcoind` or `bitcoin-qt` official bitcoin software
* encrypted and regularly backed up wallet protected by password
* set `rpcuser` and `rpcpassword` in `~/.bitcoin/bitcoin.conf`, please see https://en.bitcoin.it/wiki/Running_Bitcoin
* `bitcoin_monthly_contribute.rb` requires `bitcoind` or `bitcoin-qt -server` running. It is not required for collecting BTC addresses with `add_btc_address_to_subs_or_single_donations.rb`
* installed `zenity` (used for GTK dialogs spawned by `add_btc_address_to_subs_or_single_donations.rb`)

Installation
------------

* create ~/.bitcoin_monthly directory
* create ~/.bitcoin_monthly/bitcoin_monthly_contribute.conf.rb according to example https://github.com/ins-pirat-ion/bitcoin_monthly_contribute/blob/master/HOME_DOTbitcoin_monthly/bitcoin_monthly_contribute.conf.rb
  You have to define `Monthly_amount_in_currency` (how much do you want to spread monthly in your preferred currency), `Currency` (how do you call your currency, arbitrary string, that will affect only output messages), `Account` (label of account from which you want to send the contribution. Should have sufficient funds), `Usd_in_currency` (exchange rate between your currency and USD e.g. 1 if USD is your currency. There is automatic fetching of CZK/USD exchange rate showed in the example) values.
* maintain list of BTC addresses you want to contribute every month in `~/.bitcoin_monthly/subscriptions`, see example https://github.com/ins-pirat-ion/bitcoin_monthly_contribute/blob/master/HOME_DOTbitcoin_monthly/subscriptions
* maintain list of BTC addresses you want to contribute only this month in `~/.bitcoin_monthly/single_donations`, the format is the same. You may wish to emty this file after successful invocation of `bitcoin_monthly_contribute.rb`
* create (if not already present) `~/lib` directory
* save https://github.com/ins-pirat-ion/bitcoin_monthly_contribute/blob/master/HOME_lib/BitcoinRPC.rb library as `~/lib/BitcoinRPC.rb`
* save https://github.com/ins-pirat-ion/bitcoin_monthly_contribute/blob/master/bitcoin_monthly_contribute.rb as e.g. `~/bin/bitcoin_monthly_contribute.rb` and make it executable
* save https://github.com/ins-pirat-ion/bitcoin_monthly_contribute/blob/master/add_btc_address_to_subs_or_single_donations.rb (optional) as e.g. `~/bin/add_btc_address_to_subs_or_single_donations.rb` and make it executable

How to spread your contribution
-------------------------------

* make sure that `bitcoind` or `bitcoin-qt -server` is running
* execute `bitcoin_monthly_contribute.rb`

The script will validate all BTC addresses in `/home/fkrska/.bitcoin_monthly/subscriptions` and `/home/fkrska/.bitcoin_monthly/single_donations` and will display and ignore all invalid addresses.

All valid addresses, what are you going to spend and divide, your current balance are displayed before you are prompted to confirm whether you want to procedd.

You will be prompted for your wallet passphrase.

The transactions will be created. Note, that despite of setting transaction fee to 0 bitcoin client can send small fee anyway if the criteria are met, see https://en.bitcoin.it/wiki/Transaction_fees .

How to add bitcoin address to your lists
----------------------------------------

You can of course use your favourite text editor and edit `/home/fkrska/.bitcoin_monthly/subscriptions` and `/home/fkrska/.bitcoin_monthly/single_donations` manually. If the address on the web is not presented the standardised way (see https://en.bitcoin.it/wiki/BIP_0021) you will have to do so anyway.

If you encounter valid bitcoin: URL, you can invoke `~/bin/add_btc_address_to_subs_or_single_donations.rb` from your browser instead of official bitcoin-qt client which is usually invoked by default.

You will be prompted where you want to put the address (`subscriptions` or `single_donations` or skip) and you will be asked to create/update the label for that address.
