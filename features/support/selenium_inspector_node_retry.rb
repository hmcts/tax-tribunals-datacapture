# Chrome can report a stale DOM node as UnknownError instead of Selenium's
# StaleElementReferenceError while a page is navigating or replacing content.
# Let Capybara handle that specific inspector error through its normal retry loop.
module SeleniumInspectorNodeRetry
  TRANSIENT_INSPECTOR_NODE_ERRORS = [
    'Node with given id does not belong to the document',
    'No node with given id found',
    'Could not find node with given id'
  ].freeze

  private

  def catch_error?(error, errors = nil)
    return true if errors.nil? && transient_selenium_inspector_node_error?(error)

    super
  end

  def transient_selenium_inspector_node_error?(error)
    return false unless defined?(Selenium::WebDriver::Error::UnknownError)
    return false unless error.is_a?(Selenium::WebDriver::Error::UnknownError)

    TRANSIENT_INSPECTOR_NODE_ERRORS.any? { |message| error.message.include?(message) }
  end
end

Capybara::Node::Base.prepend(SeleniumInspectorNodeRetry)
