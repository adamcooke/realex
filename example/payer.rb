require 'lib/realex'

payer = Realex::Payer.new
payer.merchantid  = REALEX_MERCHANT_ID
payer.payerref     = 'DSW1'
payer.firstname   = 'Adam'
payer.lastname    = 'Cooke'
payer.company     = 'aTech Media2'

if payer.create
  puts payer.message
else
  puts "Failed - #{payer.message}"
end
