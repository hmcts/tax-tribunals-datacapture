RSpec.describe StrictTransportSecurityMiddleware do
  let(:app) { double('app') }
  let(:middleware) { StrictTransportSecurityMiddleware.new(app) }

  describe '#call' do
    let(:env) { { 'some_key' => 'some_value' } }
    let(:status) { 200 }
    let(:headers) { {} }
    let(:body) { ['Hello, world!'] }

    before do
      allow(app).to receive(:call).with(env).and_return([status, headers, body])
    end

    it 'sets the Strict-Transport-Security header' do
      middleware.call(env)

      expect(headers['Strict-Transport-Security']).to eq('max-age=31536000; includeSubDomains')
    end

    it 'returns the response from the app' do
      response = middleware.call(env)

      expect(response).to eq([status, headers, body])
    end
  end
end
