class StrictTransportSecurityMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    status, headers, body = @app.call(env)
    headers['Strict-Transport-Security'] = 'max-age=31536000; includeSubDomains'
    [status, headers, body]
  end
end