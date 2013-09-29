#!/usr/bin/ruby

#
# Bitcoin mothly contribute
# =========================
#
# ♡ Initial version written by Filip Krska in June 2013
# 
# Choose whatever useless (and thus not affected by the fall of the corrupted copy monopolies)
# license you want, e.g. CC0, Public domain, WTFPL, ♡ copyheart
# Be free. Use, study, audit, modify, share, profit, make love and art, not law and war.
# 
# THIS SOFTWARE COMES WITH ABSOLUTELY NO WARRANTY
#
# Uses BitcoinRPC ruby class fetched from https://en.bitcoin.it/wiki/API_reference_(JSON-RPC)#Ruby
# 
# Requires ~/.bitcoin_monthly/bitcoin_monthly_contribute.conf.rb which defines following variables:
#
# Monthly_amount_in_currency (Int)
# Currency (String)
# Btc_in_usd_ticker_cmd (String - shell command)
# Btc_in_usd = `#{btc_in_usd_ticker_cmd}`
# Usd_in_currency_ticker_cmd (String - shell command)
# Usd_in_currency = `#{Usd_in_currency_ticker_cmd}`
#
# Requires subscriptions and single_donations files in ~/.bitcoin_monthly with records like
#
# 12345678910PublicAddress4567890123		Recipient description
# 22345678910PublicAddress4567890123		Another recipient description
#
# Requires running bitcoind or bitcoin-qt -server on localhost
# and rpcuser, rpcpassword set in your ~/.bitcoin/bitcoin.conf,
# see https://en.bitcoin.it/wiki/Running_Bitcoin
#

lib_dir = File.expand_path('~/lib')
config_dir = File.expand_path('~/.bitcoin_monthly')

require "#{lib_dir}/BitcoinRPC.rb"
require "#{config_dir}/bitcoin_monthly_contribute.conf.rb"
require 'io/console'

unless (defined?(BitcoinMonthly::Monthly_amount_in_currency))
  abort "\nmonthly_amount_in_currency undefined\n"
else
  monthly_amount_in_currency = BitcoinMonthly::Monthly_amount_in_currency
end

rpcuser = ""
rpcpassword = ""

File.open(File.expand_path('~/.bitcoin/bitcoin.conf')).each_line do |line|
  if (match = /^rpcuser=(.*)$/.match(line.chomp)) then
    rpcuser = match[1]
  end
  if (match = /^rpcpassword=(.*)$/.match(line.chomp)) then
    rpcpassword = match[1]
  end
end

if (rpcuser.empty? or rpcpassword.empty?)
  abort "\nrpcuser or rpcpassword not defined.\n"
end

client = BitcoinRPC.new("http://#{rpcuser}:#{rpcpassword}@127.0.0.1:8332")

subscriptions = []
single_donations = []

puts "\nValidating addresses in #{config_dir}/subscriptions ...\n\n"

File.open("#{config_dir}/subscriptions").each_line do |line|
  if (match = /^([1-9a-zA-Z]{27,})\s+(.*)$/.match(line.chomp)) then
    if (client.validateaddress(match[1])["isvalid"]) then
      subscriptions.push([match[1], match[2]])
    else
      puts "Invalid address: #{line}\n"
      puts "Press Enter to continue\n"
      gets
    end
  end
end

puts "\nValidating addresses in #{config_dir}/single_donations ...\n\n"

File.open("#{config_dir}/single_donations").each_line do |line|
  if (match = /^([1-9a-zA-Z]{27,})\s+(.*)$/.match(line.chomp)) then
    if (client.validateaddress(match[1])["isvalid"]) then
      single_donations.push([match[1], match[2]])
    else
      puts "Invalid address: #{line}\n"
      puts "Press Enter to continue\n"
      gets
    end
  end
end

begin
  btc_in_usd = Float(BitcoinMonthly::Btc_in_usd)
rescue
  abort "\nproblem getting btc_in_usd ticker via command:\n #{BitcoinMonthly::Btc_in_usd_ticker_cmd}\n"
end

begin
  usd_in_currency = Float(BitcoinMonthly::Usd_in_currency)
rescue
  abort "\nproblem getting usd_in_currency ticker via command:\n #{BitcoinMonthly::Usd_in_currency_ticker_cmd}\n"
end

items_no = subscriptions.size + single_donations.size

btc_in_currency = btc_in_usd * usd_in_currency
monthly_amount_in_btc = monthly_amount_in_currency / btc_in_currency
btc_per_item = (monthly_amount_in_btc / items_no).round(8)
currency_per_item = btc_per_item * btc_in_currency

puts '================================================================'


printf("MONTHLY_AMOUNT_IN_CURRENCY:   %18.8f #{BitcoinMonthly::Currency}\n", monthly_amount_in_currency)
printf("MONTHLY_AMOUNT_IN_BTC:        %18.8f\n", monthly_amount_in_btc)

puts '================================================================'

printf("BTC_IN_USD:                   %18.8f\n", btc_in_usd)
printf("BTC_IN_CURRENCY:              %18.8f #{BitcoinMonthly::Currency}\n", btc_in_currency)

puts '================================================================'

printf("USD_IN_CURRENCY:              %18.8f #{BitcoinMonthly::Currency}\n", usd_in_currency)

puts '================================================================'

puts "\nSubscriptions:\n\n"

subscriptions.each {|line| puts line[0] + " " * (48 - line[0].length) + line[1]}

puts '================================================================'

puts "\nSingle donations:\n\n"

single_donations.each {|line| puts line[0] + " " * (48 - line[0].length) + line[1]}

puts '================================================================'

printf("ITEMS_NO:                     %18.8f\n", items_no)
printf("BTC_PER_ITEM:                 %18.8f\n", btc_per_item)
printf("CURRENCY_PER_ITEM:            %18.8f #{BitcoinMonthly::Currency}\n", currency_per_item)

puts '================================================================'

if ((balance = client.getbalance) < monthly_amount_in_btc) then
  abort "\nBalance #{balance} < monthly_amount #{monthly_amount_in_btc} BTC\n"
else
  puts "\nYour balance is #{balance} and you're going to spend #{items_no * btc_per_item} BTC\n\n\
        \nDo you want to proceed?(yes/[whatever else])\n"
end

want_to_proceed = gets.chomp

if (want_to_proceed == "yes")
  puts "\nOK, please, supply your wallet passphrase\n\nPassphrase: "
else
  abort "\nOK, bye...\n"
end

walletpassphrase = STDIN.noecho(&:gets).chomp

if (client.settxfee(0.0)) then
  puts "\nFee successfully set to 0\n"
else
  abort "\nError setting transaction fee\n"
end

client.walletpassphrase(walletpassphrase, 10 + 10 * items_no)

subscriptions.each {|line|
  puts "Sending #{btc_per_item} to #{line.last}. Transaction: #{client.sendtoaddress(line.first, btc_per_item)}\n"
}

single_donations.each {|line|
  puts "Sending #{btc_per_item} to #{line.last}. Transaction: #{client.sendtoaddress(line.first, btc_per_item)}\n"
}

puts "Locking the wallet\n"
client.walletlock()

