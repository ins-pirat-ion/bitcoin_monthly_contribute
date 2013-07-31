module  BitcoinMonthly
  Monthly_amount_in_currency = 2000
  Currency = "CZK"
  Usd_in_currency = `lynx --dump http://www.cnb.cz/cs/financni_trhy/devizovy_trh/kurzy_devizoveho_trhu/denni_kurz.txt\
    |grep USD|sed 's/^.*|//;s/,/./'`
end
