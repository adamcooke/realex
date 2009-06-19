module Realex
  class Payment < Base
    
    attr_accessor :payerref, :paymentmethod, :autosettle

    def process
      post xml
    end
    
    private
    
    def xml
      xml = Builder::XmlMarkup.new
      xml.request(:type => "receipt-in", :timestamp => self.timestamp) do
        xml.sha1hash self.sha1hash
        xml.merchantid self.merchantid
        xml.orderid self.orderid
        xml.payerref self.payerref
        xml.autosettle(:flag => (self.autosettle ? '1' : '0'))
        xml.paymentmethod self.paymentmethod
        xml.amount(self.amount, :currency => self.currency) 
      end
    end
    
  end
end
