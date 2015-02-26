#!/usr/bin/ruby

config_dir = File.expand_path('~/.bitcoin_monthly')

require 'uri'

uri = URI(ARGV.join)

if (uri.scheme != "bitcoin") then
  zenity_out = `zenity --info --text "Not a bitcoin URI.\n\n\
Refer to https://github.com/bitcoin/bips/blob/master/bip-0021.mediawiki#Examples\n\n\
eg.  bitcoin:1dprQf6srGtsNhgP82CT8QWUpUrMtXjiH?label=bitcoin_monthly_contribute"`
  abort
end

if (match = /^([1-9a-zA-Z]{27,})(\?(.*))?$/.match(uri.opaque)) then
  address = match[1]
  zenity_out = `zenity --info --text "Note: the bitcoin address is not being validated.\n\
You can safely ignore this warning.\n\
Addresses are validated by bitcoin_monthly_contribute.rb before creating transactions."`
  if (!(match[3].nil?) and URI.decode_www_form(match[3]).assoc('label').respond_to?("last")) then
    label = URI.decode_www_form(match[3]).assoc('label').last
  else
    label = ""
  end
  label = `zenity --entry --entry-text="#{label}" --text "Set label for address: #{address}"`
else
  zenity_out = `zenity --info --text "Bitcoin URI invalid"`
  abort
end

zenity_out = `zenity --list --radiolist --column="" --column=File --text "Where you want to add the address to?\
" --height=300 FALSE subscriptions FALSE single_donations TRUE "Cancel Action"`.chomp

if (["single_donations", "subscriptions"].include?zenity_out) then
  file = "#{config_dir}/#{zenity_out}"
else
  zenity_out = `zenity --info --text "Action Cancelled"`
  abort
end

if (File.writable?(file)) then
  zenity_out = `zenity --info --text "Updating #{file}"`
  open(File.open(file, File::APPEND), mode: "a").write(address + " " * (48 - address.length) + label)
else
  zenity_out = `zenity --info --text "Cannot open #{file} for writing"`
  abort
end


