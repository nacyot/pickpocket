module Pickpocket
  class PocketClient
    include ::Singleton

    def modify(items)
      @pocket.modify items
    end
    
    private
    def initialize
      set_pocket_configuration
    end
    
    def set_pocket_configuration
      ::Pocket.configure do |config|
        config.consumer_key = ENV['POCKET_CONSUMER_KEY']
      end
      
      @pocket = ::Pocket.client(:access_token => ENV['POCKET_OAUTH_TOKEN'])
    end
  end
end
