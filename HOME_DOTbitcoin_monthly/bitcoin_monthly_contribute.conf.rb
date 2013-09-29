module  BitcoinMonthly
  Monthly_amount_in_currency = 2500

  Currency = "CZK"

  Btc_in_usd_ticker_cmd = 'lynx --dump http://data.mtgox.com/api/1/BTCUSD/ticker\
    |sed \'s/^.*buy":{"value":"//;s/".*$//\''
  Btc_in_usd = `#{btc_in_usd_ticker_cmd}`

  Usd_in_currency_ticker_cmd = "lynx --dump http://www.cnb.cz/cs/financni_trhy/devizovy_trh/kurzy_devizoveho_trhu/denni_kurz.txt\
    |grep USD|sed 's/^.*|//;s/,/./'"
  Usd_in_currency = `#{Usd_in_currency_ticker_cmd}`
end
