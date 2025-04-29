RSpec.describe Employees::PasswordsController do
  let(:employee) { FactoryBot.create(:employee) }

  before do
    request.env['devise.mapping'] = Devise.mappings[:employee]
    allow(NotifyMailer).to receive_message_chain(:reset_password_instructions, :deliver)
  end

  describe '#after_sending_reset_password_instructions_path_for' do
    it 'redirects to the root path' do
      post :create, params: { employee: { email: employee.email } }
      allow(subject).to receive(:after_sending_reset_password_instructions_path_for).and_return(new_employee_session_path)
    end
  end

  describe '#create' do

    context 'when the employee exists' do
      it 'sends reset password instructions' do
        post :create, params: { employee: { email: employee.email } }
        expect(response).to redirect_to(new_employee_session_path)
        expect(NotifyMailer).to have_received(:reset_password_instructions)
      end
    end

    context 'when the email is blank' do
      it 'renders the new template with a flash notice' do
        post :create, params: { employee: { email: '' } }
        expect(response).to render_template(:new)
        expect(flash[:notice]).to eq('Email cannot be blank')
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
