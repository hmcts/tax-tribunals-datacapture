module EmployeeHelper
  def employee_last_logged_in_at(employee)
    return 'N/A' if employee.last_sign_in_at.nil?
    employee.last_sign_in_at&.strftime("%B %d, %Y - %I:%M %p")
  end
end