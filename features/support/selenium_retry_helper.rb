def transient_inspector_node_error?(error)
  error.message.include?('Node with given id does not belong to the document')
end

def retry_transient_inspector_node_error(reset_session: true)
  attempts = 0

  begin
    yield
  rescue Selenium::WebDriver::Error::UnknownError => e
    raise unless transient_inspector_node_error?(e) && attempts.zero?

    attempts += 1
    warn "Retrying after transient Selenium inspector error"
    if reset_session
      Capybara.reset_sessions!
    else
      sleep 0.5
    end
    retry
  end
end
