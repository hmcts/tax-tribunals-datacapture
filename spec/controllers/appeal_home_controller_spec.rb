require 'rails_helper'

RSpec.describe AppealHomeController do
  describe '#index' do
    it 'renders the expected page' do
      local_get :index
      expect(response).to render_template(:index)
    end

    it 'should initialise a tribunal case' do
      local_get :index
      expect(controller.send(:current_tribunal_case)).not_to be_nil
    end
  end
end
