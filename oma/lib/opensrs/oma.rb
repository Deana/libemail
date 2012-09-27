require 'net/http'
require 'net/https'
require 'addressable/uri'
require 'json'

module OpenSRS
  module JsonRPC
    class Client
  
      def initialize(url, creds)
        @base = url
        @creds = creds
      end

      def uri ( method = '' )
        URI.parse( @base )
      end
  
      def request(method, params = {})
        params["credentials"] = @creds
  
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
       
        request = Net::HTTP::Post.new( uri.request_uri )
        request["Content-Type"] = "application/json"
        request.body = params.to_json
       
        response = http.request( request )
        return JSON.parse(response.read_body)
      end
    end
  end

  class InvalidCredentials < Exception; end

  module ErrorHandler
    def valid?( response )
      unless response["success"]
        if response["error"] =~ /Invalid credentials supplied in request/
          raise InvalidCredentials, response["error"]
        end
          raise Exception, response["error"]
      end
      response
    end
  end

  class OMA < JsonRPC::Client
    VERSION = '0.0.2'

    include ErrorHandler

    attr_accessor  :url
    attr_accessor  :username
    attr_accessor  :password
    attr_reader    :methods
  
    def initialize( opt={} )
      #OMA.create_methods

      @username = opt[:username] || ''
      @password = opt[:password] || ''
  
      @url = opt[:url] || 'https://admin.a.hostedemail.com/api'
      @credentials = { :client => "Ruby OpenSRS::OMA 0.0.2", :user => @username, :password => @password }
      super( @url, @credentials )
    end
 
    def uri ( method = @method )
      URI.parse( @base + "/" + method.to_s)
    end

    # removed, in favour of metaprogramming 
    METHODS = %w(  )

    # This method is deprecated..
    def self.create_methods
      METHODS.each do |method|
        define_method method do |*argv|
          @method = method
          valid?( request method, *argv )     
        end
      end
    end

    def method_missing( m, *args, &block )
      @method = m
      request( m, *args )
    end
  end
end

