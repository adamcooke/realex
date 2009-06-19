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
      @timestamp ||= Time.now.strftime("%Y%m%d%H%M%S")
    end
    
    def result
      @xml ? @xml["result"].first.to_i : nil
    end
    
    def message
      @xml ? @xml["message"].first : nil
    end
    
    def successful?
      @xml ? self.result == 0 : false
    end
    
    def response
      @xml
    end
    
    private
    
    def post(xml)
      uri = URI.parse("https://epage.payandshop.com/epage-remote-plugins.cgi")
      req = Net::HTTP::Post.new(uri.path)
      req.body = xml
      
      res = Net::HTTP.new(uri.host, uri.port)
      res.use_ssl = true
      
      root_ca = File.join(File.dirname(__FILE__), 'ca-bundle.crt')
      if File.exist?(root_ca)
        res.ca_file = root_ca
        res.verify_mode = OpenSSL::SSL::VERIFY_PEER
        res.verify_depth = 5
      else
        res.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end
      
      Timeout::timeout(10) do
        res = res.request(req)
      end
      
      case res
      when Net::HTTPSuccess
        @xml = XmlSimple.xml_in(res.body)
        self.successful?
      else
        raise "Connection Error"
      end

    rescue Timeout::Error
      raise "Connection Timed Out"
    end
    
  end
end
