require 'rails_helper'

RSpec.describe Employee, type: :model do
  describe '#admin?' do
    it 'returns true if the role is admin' do
      employee = Employee.new(role: 'admin')
      expect(employee.admin?).to be true
    end

    it 'returns false if the role is not admin' do
      employee = Employee.new(role: 'user')
      expect(employee.admin?).to be false
    end
  end

  describe '#active?' do
    it 'returns false if last_sign_in_at is within the last 3 months' do
      employee = Employee.new(last_sign_in_at: 2.months.ago)
      expect(employee.active?).to be true
    end

    it 'returns true if last_sign_in_at is more than 3 months ago' do
      employee = Employee.new(last_sign_in_at: 4.months.ago)
      expect(employee.active?).to be false
    end

    it 'returns false if never signed in' do
      employee = Employee.new(last_sign_in_at: nil)
      expect(employee.active?).to be false
    end
  end

  describe 'scopes' do
    let(:employee1) { FactoryBot.create(:employee, last_sign_in_at: 2.months.ago) }
    let(:employee2) { FactoryBot.create(:employee, last_sign_in_at: 3.months.ago) }
    let(:employee3) { FactoryBot.create(:employee, last_sign_in_at: nil) }
    before do
      employee1
      employee2
      employee3
    end

    describe '.active_list' do
      it 'returns employees who have signed in within the last 3 months' do
        list = Employee.active_list
        expect(list).to include(employee1)
        expect(list).not_to include(employee2)
        expect(list).not_to include(employee3)
      end
    end

    describe '.inactive_list' do
      it 'returns employees who have signed in within the last 3 months' do
        list = Employee.inactive_list
        expect(list).not_to include(employee1)
        expect(list).to include(employee2)
        expect(list).to include(employee3)
      end
    end
  end
end
