def transient_inspector_node_error?(error)
  error.message.include?('Node with given id does not belong to the document')
end

def retry_transient_inspector_node_error
  attempts = 0

  begin
    yield
  rescue Selenium::WebDriver::Error::UnknownError => e
    raise unless transient_inspector_node_error?(e) && attempts.zero?

    attempts += 1
    warn "Retrying after transient Selenium inspector error"
    Capybara.reset_sessions!
    retry
  end
end
