require 'lib/realex'

card = Realex::Card.new
card.merchantid  = REALEX_MERCHANT_ID
card.ref = 'visa01'
card.payerref = 'DSW1'
card.number = 4263971921001307
card.expdate = "0110"
card.chname = 'John Smith'
card.type = 'visa'

if card.create
  puts card.message
else
  puts "Failed - #{card.message}"
end
