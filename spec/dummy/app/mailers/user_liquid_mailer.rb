class UserLiquidMailer < Effective::LiquidMailer
  def after_create_user
    @user_name = "nathan"
    @to_liquid = {
      'user_name' => 'nathan'
    }
    mail(to: 'users_email@example.com')
  end
end

