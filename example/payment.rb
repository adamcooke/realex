require 'lib/realex'

payment = Realex::Payment.new
payment.merchantid  = REALEX_MERCHANT_ID
payment.payerref = 'DSW1'
payment.paymentmethod = 'visa01'
payment.amount = 1000
payment.currency = 'EUR'
payment.autosettle = true

if payment.process
  puts payment.message
else
  puts "Failed - #{payment.message}"
end
