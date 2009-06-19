module Realex
  class Payer < Base
    
    attr_accessor :firstname, :lastname, :company, :ref

    def create
      post xml('new')
    end
    
    def update
      post xml('edit')
    end
    
    private
    
    def xml(method = 'new')
      xml = Builder::XmlMarkup.new
      xml.request(:type => "payer-#{method}", :timestamp => self.timestamp) do
        xml.sha1hash self.sha1hash
        xml.merchantid self.merchantid
        xml.orderid self.orderid
        xml.payer(:type => 'Business', :ref => self.payerref) do
          xml.firstname   self.firstname
          xml.lastname self.lastname
          xml.company self.company
        end
      end
    end
    
  end
end
