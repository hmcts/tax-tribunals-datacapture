require 'spec_helper'

class DummyClass
  include GlimrDirectApiClient::Api

  def endpoint
    '/endpoint'
  end

  def request_body
    { parameter: 'parameter' }
  end
end

RSpec.describe GlimrDirectApiClient::Api do
  let(:subject) { DummyClass.new }

  describe '#post' do
    let(:body) { { response: 'response' } }

    before do
      # stub ENV
      allow(ENV).to receive(:fetch).with('GLIMR_API_URL')
        .and_return('https://glimr-api.taxtribunals.dsd.io/Live_API/api/tdsapi')
      allow(ENV).to receive(:fetch).with('GLIMR_DIRECT_API_URL')
        .and_return('https://glimr-api.taxtribunals.dsd.io/Live_API/api/tdsapi2')
      allow(ENV).to receive(:fetch).with('GLIMR_DIRECT_ENABLED', 'false')
        .and_return('true')
      allow(ENV).to receive(:fetch).with('GLIMR_AUTHORIZATION_KEY', '').and_return('key')
      allow(ENV).to receive(:fetch).with('GLIMR_REGISTER_NEW_CASE_TIMEOUT_SECONDS', 32).and_return('32')
      allow(ENV).to receive(:fetch).with('GLIMR_API_DEBUG', '').and_return('false')
      stub_request(:post, /endpoint$/)
        .to_return(status: 200, body: body.to_json)
    end

    it 'sends request_body as JSON' do
      expect(subject).to receive(:make_request)
        .with("https://glimr-api.taxtribunals.dsd.io/Live_API/api/tdsapi2/endpoint",
              { parameter: 'parameter' }.to_json)
      subject.post
    end

    it 'sets the response_body from the #post call' do
      subject.post
      expect(subject.response_body).to eq({ response: 'response' })
    end

    context 'timeout' do
      before do
        stub_request(:post, /endpoint$/).to_timeout
      end

      it 'raises Unavailable "timed out"' do
        expect { subject.post }.to raise_error(GlimrDirectApiClient::Unavailable, 'timed out')
      end
    end
  end

  describe 'configuration' do
    it 'fetches the glimr api endpoint from ENV, sets default if not available' do
      allow(ENV).to receive(:fetch).with('GLIMR_DIRECT_ENABLED', 'false')
        .and_return('true')
      expect(ENV).to receive(:fetch)
        .with('GLIMR_DIRECT_API_URL')
      subject.send(:api_url)
    end
  end

  describe 'REST client' do
    before do
      allow(ENV).to receive(:fetch).with('GLIMR_API_URL').and_return('https://glimr-api-emulator.herokuapp.com/Live_API/api/tdsapi/')
      allow(ENV).to receive(:fetch).with('GLIMR_DIRECT_API_URL').and_return('https://glimr-api-emulator.herokuapp.com/Live_API/api/tdsapi/')
      allow(ENV).to receive(:fetch).with('GLIMR_DIRECT_ENABLED', 'false')
        .and_return('true')
      allow(ENV).to receive(:fetch).with('GLIMR_AUTHORIZATION_KEY', '').and_return('key')
      allow(ENV).to receive(:fetch).with('GLIMR_REGISTER_NEW_CASE_TIMEOUT_SECONDS', 32).and_return('32')
      allow(ENV).to receive(:fetch).with('GLIMR_API_DEBUG', '').and_return('false')
      stub_request(:post, /endpoint$/)
        .to_return(status: 200, body: {response: 'response'}.to_json)
    end

    it 'sends the correct headers' do
      headers = { 'Content-Type' => 'application/json', 'Accept' => 'application/json', 'Authorization' => 'apikey key' }
      expect(RestClient::Request).to receive(:execute).with(hash_including(headers:)).and_call_original
      subject.post
    end

    describe 'parsing the JSON response' do
      let(:parsed_response) { instance_double(Hash, key?: false, empty?: false) }

      before do
        stub_request(:post, /endpoint$/)
          .to_return(status: 200, body: {response: 'response'}.to_json)
        allow(JSON).to receive(:parse).and_return(parsed_response)
      end

      it 'symbolizes the keys' do
        expect(JSON).to receive(:parse).with(anything, symbolize_names: true)
        subject.post
      end
    end

  end

end
