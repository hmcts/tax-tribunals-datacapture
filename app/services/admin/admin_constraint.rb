class Admin::AdminConstraint
  def self.matches?(request)
    return false unless request.env['warden'].authenticate?

    user = request.env['warden'].user
    user.admin?
  end
end