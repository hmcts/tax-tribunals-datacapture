RSpec.describe Employees::PasswordsController do
  before do
    request.env['devise.mapping'] = Devise.mappings[:employee]
    allow(NotifyMailer).to receive_message_chain(:reset_password_instructions, :deliver)
  end

  describe '#after_sending_reset_password_instructions_path_for' do
    it 'redirects to the root path' do
      expect(subject.after_sending_reset_password_instructions_path_for(:employee)).to eq(root_path)
    end
  end

  describe '#create' do
    let(:employee) { FactoryBot.create(:employee) }

    context 'when the employee exists' do
      it 'sends reset password instructions' do
        post :create, params: { employee: { email: employee.email } }
        expect(response).to redirect_to(root_path)
        expect(NotifyMailer).to have_received(:reset_password_instructions)
      end
    end

    # TODO
    # context 'when the employee does not exist' do
    #   it 'renders the new template' do
    #     post :create, params: { employee: { email: 'nonexistent@example.com' } }
    #     expect(response).to render_template(:new)
    #   end
    # end
  end
end