class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  after_create :after_create

  private

  def after_create
    mail = UserLiquidMailer.after_create_user
    mail.deliver
  end
end
