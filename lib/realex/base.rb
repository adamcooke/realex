module Realex
  class Base
    
    attr_accessor :merchantid, :orderid, :amount, :currency, :payerref
    
    def orderid
      @orderid || "order#{timestamp}"
    end
    
    def sha_string
      [self.timestamp, self.merchantid, self.orderid, self.amount, self.currency, self.payerref].join('.')
    end
    
    def sha1hash
      Digest::SHA1.hexdigest([Digest::SHA1.hexdigest(sha_string), REALEX_SECRET].join('.'))
    end
    
    def timestamp
      Time.now.strftime("%Y%m%d%H%M%S")
    end
    
    private
    
    def post(xml)
      puts xml
      uri = URI.parse("https://epage.payandshop.com/epage-remote-plugins.cgi")
      req = Net::HTTP::Post.new(uri.path)
      req.set_form_data({:xml => xml})
      
      res = Net::HTTP.new(uri.host, uri.port)
      res.use_ssl = true
      
      Timeout::timeout(10) do
        res = res.request(req)
      end
      
      case res
      when Net::HTTPSuccess
        res.body
      else
        raise "Connection Error"
      end

    rescue Timeout::Error
      raise "Connection Timed Out"
    end
    
  end
end
