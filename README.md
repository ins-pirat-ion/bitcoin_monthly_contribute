bitcoin_monthly_contribute
==========================

Scripts to ease regular bitcoin donations to several addresses.

Inspired by the awesome `Flattr` idea.

Thanks to the scriptability of `bitcoin` network `bitcoin_monthly_contribute` doesn't require any service provider solution. All you need is couple of simple free software scripts on your box.

Collection of bitcoin addresses can be done easily with `add_btc_address_to_subs_or_single_donations.rb` which works well with donation buttons like http://coinwidget.com/ or https://bitcoinwidget.appspot.com/ or simply bitcoin: URL defined in https://en.bitcoin.it/wiki/BIP_0021

Files
-----

<dl>
  <dt>HOME_lib/BitcoinRPC.rb</dt>
  <dd>`BitcoinRPC` class taken from:

  https://en.bitcoin.it/wiki/API_reference_(JSON-RPC)#Ruby

  so it is `CC-BY` according to https://en.bitcoin.it/wiki/Bitcoin.it_Wiki#License

  But to whom should I give credit? OK, let's try https://en.bitcoin.it :).

  All the other files are Public Domain (or `Unlicense`, `WTFPL`, `Copyheart`, `CC0` if you prefer). However, licenses and corrupted copy monopolies will die anyway so it doesn't matter.</dd>
  <dt>bitcoin_monthly_contribute.rb</dt>
  <dd> The main script.

  Takes all valid BTC public addresses from `~/.bitcoin_monthly/subscriptions` and  `~/.bitcoin_monthly/single_donations`, splits `Monthly_amount_in_currency` defined in `~/.bitcoin_monthly/bitcoin_monthly_contribute.conf.rb` into equal pieces, connects to running `bitcoind` or `bitcoin-qt -server` with credentials defined in `~/.bitcoin/bitcoin.conf` and sends the bitcoins to your beloved projects.</dd>
  <dt>HOME_DOTbitcoin_monthly/subscriptions</dt>
  <dt>HOME_DOTbitcoin_monthly/single_donations</dt>
  <dd>Examples of the addresses files. Should be present in `~/.bitcoin_monthly/` directory.</dd>
  <dt>HOME_DOTbitcoin_monthly/bitcoin_monthly_contribute.conf.rb</dt>
  <dd>Example of configuration file. Defines:
  * `Monthly_amount_in_currency`
  * Currency code
  * Label of account from which you want to send the contribution. Should have sufficient funds
  * `Usd_in_currency` exchange rate, `Usd_in_currency_ticker_cmd` shell command to obtain it
  * `Btc_in_usd` exchange rate, `Btc_in_usd_ticker_cmd` shell command to obtain it</dd>
  <dt>add_btc_address_to_subs_or_single_donations.rb</dt>
  <dd>Script that can be invoked from your browser  as an application taking bitcoin: URL defined in https://en.bitcoin.it/wiki/BIP_0021 which will ask you if you want to add the addres (and label it) to `subscriptions` or `single_donations` file or cancel.

  Employs `zenity`.</dd>

Donations
---------

I'm happily employed and I don't expect donations in order to maintain these simple scripts.

However I've already obtained some unexpected love thanks to awesome Flattr--GitHub integration: https://flattr.com/thing/1748778/ins-pirat-ionbitcoinmonthlycontribute-on-GitHub so I decided to offer BTC donation option, too so I (and you) have comparison, how different methods work.

The BTC address for donations is bitcoin:1dprQf6srGtsNhgP82CT8QWUpUrMtXjiH

I don't know how to present it as clickable URL here because [GFM](https://help.github.com/articles/github-flavored-markdown) doesn't support arbitrary HTML code insertion. You can click on it on my ugly outdated [bookmarks site](http://lillek.wz.cz/).

I'll spread every donation made to this "project" either via Flattr or Bitcoin back to the Free Sofware, Free Culture creators or privacy, human rights and related activists/groups. If I'm not lazy, I'll post transparency reports here or on my [blog](https://diasp.org/u/fill_io).
