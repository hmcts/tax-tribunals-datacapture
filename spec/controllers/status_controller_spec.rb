require 'rails_helper'

RSpec.describe TaxTribs::StatusController do
  let(:status) do
    {
      service_status: 'ok',
      version: 'ABC123',
      dependencies: {
      glimr_status: 'ok',
      database_status: 'ok'
    }
    }.to_json
  end


  let(:glimr_status) do
    {
      glimr_status: 'ok'
    }.to_json
  end

  describe '#glimr' do
    before do
      stub_request(:post, /glimravailable/).
        to_return(body: { glimrAvailable: 'yes' }.to_json)
    end

    specify do
      get :glimr
      expect(response.status).to eq(200)
    end

    it 'returns json' do
      get :glimr
      expect(response.body).to eq(glimr_status)
    end
  end

  # This is very-happy-path to ensure the controller responds.  The bulk of the
  # status is tested in spec/services/status_spec.rb.
  describe '#index' do
    before do
      # Stubbing GlimrApiClient does not work here for some reason Stubbing
      # GlimrApiClient does not work here for some reason that isn't clear.
      stub_request(:post, /glimravailable/).
        to_return(body: { glimrAvailable: 'yes' }.to_json)
      stub_request(:get, /health/).
        to_return(status: 200, body: { service_status: 'ok' }.to_json)
      expect(ActiveRecord::Base).to receive(:connection).and_return(double)
      allow_any_instance_of(TaxTribs::Status).to receive(:version).and_return('ABC123')
    end
    
    specify do
      get :index
      expect(response.status).to eq(200)
    end

    it 'returns json' do
      get :index
      expect(response.body).to eq(status)
    end
  end

  describe '#liveness' do
    specify do
      get :liveness
      expect(response.status).to eq(200)
      expect(response.body).to eq({ status: 'ok' }.to_json)
    end
  end

  describe '#readiness' do
    specify do
      get :readiness
      expect(response.status).to eq(200)
      expect(response.body).to eq({ status: 'ok' }.to_json)
    end
  end
end
