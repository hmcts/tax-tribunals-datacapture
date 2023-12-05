require 'zendesk_api'

ZENDESK_CLIENT = ZendeskAPI::Client.new do |config|
  config.url = 'https://tax-tribunals.zendesk.com/api/v2'
  config.username = ENV.fetch('ZENDESK_USERNAME', nil)
  config.token = ENV.fetch('ZENDESK_TOKEN', nil)

  require 'logger'
  config.logger = Logger.new('log/zendesk.log')
  config.logger.level = Logger::DEBUG
end
