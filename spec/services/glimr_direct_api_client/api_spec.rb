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
      allow(ENV).to receive(:fetch).with('GLIMR_API_URL').
        and_return('https://glimr-api.taxtribunals.dsd.io/Live_API/api/tdsapi')
      stub_request(:post, /endpoint$/)
        .to_return(status: 200, body: body.to_json)
    end

    it 'sends request_body as JSON' do
      expect(subject).to receive(:make_request).
        with("https://glimr-api.taxtribunals.dsd.io/Live_API/api/tdsapi/endpoint",
        { parameter: 'parameter' }.to_json)
      subject.post
    end

    it 'sets the response_body from the #post call' do
      subject.post
      expect(subject.response_body).to eq({ response: 'response' })
    end
  end

  describe 'configuration' do
    it 'fetches the glimr api endpoint from ENV, sets default if not available' do
      expect(ENV).to receive(:fetch)
        .with('GLIMR_API_URL')
      subject.send(:api_url)
    end
  end

  describe 'REST client' do
    before do
      stub_request(:post, /endpoint$/)
        .to_return(status: 200, body: {response: 'response'}.to_json)
    end

    it 'sends the correct headers' do
      headers = { 'Content-Type' => 'application/json', 'Accept' => 'application/json' }
      expect(RestClient::Request).to receive(:execute).with(hash_including(headers: headers)).and_call_original
      subject.post
    end
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
