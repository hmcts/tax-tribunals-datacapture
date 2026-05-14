def transient_inspector_node_error?(error)
  error.message.include?('Node with given id does not belong to the document')
end

def recovered_from_transient_inspector_node_error?(reset_session:, success_condition:)
  return true if success_condition&.call

  if reset_session
    Capybara.reset_sessions!
  else
    sleep 0.5
  end

  success_condition&.call
end

def retry_transient_inspector_node_error(reset_session: true, success_condition: nil)
  attempts = 0

  begin
    yield
  rescue Selenium::WebDriver::Error::UnknownError => e
    raise unless transient_inspector_node_error?(e) && attempts.zero?

    attempts += 1
    warn "Retrying after transient Selenium inspector error"
    return if recovered_from_transient_inspector_node_error?(reset_session:, success_condition:)

    retry
  end
end
