module  BitcoinMonthly
  Monthly_amount_in_currency = 2500

  Currency = "CZK"

  Account = "Contribute"

  Btc_in_usd_ticker_cmd = 'curl -k https://api.coindesk.com/v1/bpi/currentprice/USD.json\
    |sed \'s/^.*"rate":"//;s/".*$//;s/,//\''
  Btc_in_usd = `#{Btc_in_usd_ticker_cmd}`

  Usd_in_currency_ticker_cmd = "curl http://www.cnb.cz/cs/financni_trhy/devizovy_trh/kurzy_devizoveho_trhu/denni_kurz.txt\
    |grep USD|sed 's/^.*|//;s/,/./'"
  Usd_in_currency = `#{Usd_in_currency_ticker_cmd}`
end
