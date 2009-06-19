module Realex
  class Card < Base
    
    attr_accessor :ref, :payerref, :number, :expdate, :chname, :type, :issueno

    def create
      post xml
    end
    
    def sha_string
      [self.timestamp, self.merchantid, self.orderid, self.amount, self.currency, self.payerref, self.chname, self.number].join('.')
    end

    private
    
    def xml
      xml = Builder::XmlMarkup.new
      xml.request(:type => "card-new", :timestamp => self.timestamp) do
        xml.sha1hash self.sha1hash
        xml.merchantid self.merchantid
        xml.orderid self.orderid
        xml.card do
          xml.ref self.ref
          xml.payerref self.payerref
          xml.number self.number
          xml.expdate self.expdate
          xml.chname self.chname
          xml.type self.type
          xml.issueno self.issueno
        end
      end
    end
    
  end
end
