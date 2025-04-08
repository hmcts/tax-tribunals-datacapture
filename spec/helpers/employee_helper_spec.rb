require 'rails_helper'

RSpec.describe EmployeeHelper, type: :helper do
  describe '#employee_last_logged_in_at' do
    let(:employee) { double('Employee') }

    context 'when last_sign_in_at is nil' do
      it 'returns "N/A"' do
        allow(employee).to receive(:last_sign_in_at).and_return(nil)
        expect(helper.employee_last_logged_in_at(employee)).to eq('N/A')
      end
    end

    context 'when last_sign_in_at is present' do
      it 'returns the formatted date and time' do
        time = Time.new(2023, 10, 5, 14, 30)
        allow(employee).to receive(:last_sign_in_at).and_return(time)
        expect(helper.employee_last_logged_in_at(employee)).to eq('October 05, 2023 - 02:30 PM')
      end
    end
  end
end