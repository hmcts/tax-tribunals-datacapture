require 'rails_helper'

RSpec.shared_examples 'a password-protected admin controller' do |method|

  let(:user) { FactoryBot.create(:user) }
  let(:admin) { FactoryBot.create(:user, admin: true) }

  context "when user is not authenticated" do
    it "redirects to login page" do
      local_get method
      expect(response).to redirect_to(new_user_session_path(locale: I18n.locale))
    end
  end

  context "when user is not an admin" do
    before do
      sign_in user
    end

    it "signs out user and redirects with an alert" do
      local_get method
      expect(response).to redirect_to(new_user_session_path(locale: I18n.locale))
      expect(flash[:alert]).to eq("You are not authorized to view this page.")
    end
  end

  context "when user is an admin" do
    before do
      sign_in admin
    end

    it "allows access to the controller action" do
      local_get method
      expect(response).to have_http_status(:success)  # Or other expected behavior
    end
  end
end
