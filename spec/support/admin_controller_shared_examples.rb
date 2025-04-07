RSpec.shared_examples "a password-protected admin controller" do |action|
  context "when employee is not signed in" do
    it "redirects to the sign in page" do
      local_get action
      expect(response).to redirect_to(new_employee_session_path)
    end
  end

  context "when employee is signed in" do
    before do
      sign_in double("employee")
    end

    it "does not redirect to the sign in page" do
      local_get action
      expect(response).not_to redirect_to(new_employee_session_path)
    end
  end
end