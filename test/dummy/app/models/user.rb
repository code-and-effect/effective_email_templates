class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  def to_s
    "#{first_name} #{last_name}"
  end

end
