require 'rails_helper'

RSpec.describe 'external dependencies routes', type: :routing do
  describe 'root' do
    specify { expect(get: '/').to route_to(controller: 'home', action: 'index') }

    context 'localized in english' do
      specify { expect(get: '/en').to route_to(controller: 'home', action: 'index', locale: 'en') }
    end

    context 'localized in welsh' do
      specify { expect(get: '/cy').to route_to(controller: 'home', action: 'index', locale: 'cy') }
    end
  end

  describe 'health checks' do
    specify do
      expect(get: '/health').to route_to(
        controller: 'tax_tribs/status',
        action: 'index'
      )
      expect(get: '/health/liveness').to route_to(
        controller: 'tax_tribs/status',
        action: 'liveness'
      )
      expect(get: '/health/readiness').to route_to(
        controller: 'tax_tribs/status',
        action: 'readiness'
      )
    end
  end
end
