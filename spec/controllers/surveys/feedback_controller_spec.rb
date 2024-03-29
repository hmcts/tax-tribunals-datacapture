require 'rails_helper'

RSpec.describe Surveys::FeedbackController, type: :controller do
  describe '#new' do
    it 'responds with HTTP success' do
      local_get :new
      expect(response).to be_successful
    end
  end

  describe '#create' do
    let(:form_object) {double('form object', save: saved)}

    before do
      request.env['HTTP_USER_AGENT'] = 'Safari'

      expect(Surveys::FeedbackForm).to receive(:new).with(
        rating:,
        comment: 'my feedback here',
        referrer: '/my/step',
        user_agent: 'Safari'
      ).and_return(form_object)
    end

    context 'when the form object saves successfully' do
      let(:rating) { '5' }
      let(:saved) { true }

      it 'redirects to thanks page' do
        local_post :create, params: {surveys_feedback_form: {
          referrer: '/my/step',
          rating:,
          comment: 'my feedback here'
        }}

        expect(response).to redirect_to(thanks_surveys_feedback_path)
      end
    end

    context 'when the form object does not save successfully' do
      let(:rating) { '10' }
      let(:saved) { false }

      it 're-renders the form' do
        local_post :create, params: {surveys_feedback_form: {
          referrer: '/my/step',
          rating:,
          comment: 'my feedback here'
        }}

        expect(subject).to render_template(:new)
      end
    end
  end
end
