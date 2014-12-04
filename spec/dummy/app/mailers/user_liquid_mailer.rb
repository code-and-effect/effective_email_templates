class UserLiquidMailer < Effective::LiquidMailer
  def after_create_user
    mail(to: 'users_email@example.com')
  end
end

