class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  # effective_email_templates_organization_user
  # effective_email_templates_user

  def to_s
    "#{first_name} #{last_name}"
  end

end
