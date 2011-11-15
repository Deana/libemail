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
  
      def request(method, params = {})
        params["credentials"] = @creds
  
        uri = URI.parse( @base + "/" + method.to_s)

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
      end
      response
    end
  end

  class OMA < JsonRPC::Client
    VERSION = '0.01'

    include ErrorHandler

    attr_accessor  :url
    attr_accessor  :username
    attr_accessor  :password
    attr_reader    :methods
  
    def initialize( opt={} )
      OMA.create_methods
      @methods = METHODS

      @username = opt[:username] || ''
      @password = opt[:password] || ''
  
      @url = opt[:url] || 'https://admin.a.hostedemail.com/api'
      @credentials = { :client => "Ruby OpenSRS::OMA 0.01", :user => @username, :password => @password }
      super( @url, @credentials )
    end
  
    METHODS = %w(
      add_role
      authenticate
      change_company
      change_company_bulletin
      change_domain
      change_domain_bulletin
      change_user
      change_brand
      create_workgroup
      delete_company
      delete_domain
      delete_user
      delete_workgroup
      echo
      generate_token
      get_company
      get_company_bulletin
      get_company_changes
      get_deleted_contacts
      get_deleted_messages
      get_domain
      get_domain_bulletin
      get_domain_changes
      get_user
      get_user_attribute_history
      get_user_changes
      get_user_messages
      get_valid_languages
      get_valid_timezones
      migration_add
      migration_jobs
      migration_status
      migration_threads
      migration_trace
      move_user_messages
      post_domain_bulletin
      post_company_bulletin
      remove_role
      rename_user
      restore_deleted_contacts
      restore_deleted_messages
      restore_domain
      restore_user
      search_brand_members
      search_brands
      search_companies
      search_domains
      search_users
      search_workgroups
      set_role
      stats_summary
      stats_list
      stats_snapshot )

    def self.create_methods
      METHODS.each do |method|
        define_method method do |*argv|
          valid?( request method, *argv )     
        end
      end
    end
  end
end

