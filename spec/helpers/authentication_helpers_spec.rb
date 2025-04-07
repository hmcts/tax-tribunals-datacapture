module AuthenticationHelpers
  def sign_in(user = double('user'))
    allow(request.env['warden']).to receive(:authenticate!).and_return(user)
    allow(controller).to receive(:current_user).and_return(user)
  end

  def sign_in_employee(employee)
    allow(request.env['warden']).to receive(:authenticate!).and_return(employee)
    allow(controller).to receive(:current_employee).and_return(employee)
  end
end
