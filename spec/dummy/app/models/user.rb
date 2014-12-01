class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  after_create :after_create

  private

  def after_create
    template = EffectiveEmailTemplates.get(:after_create_user)

    if template.valid?
      render_options = {}
      mail = template.prepare({ to: 'some_admin@example.com' })
      mail.deliver
    end
  end
end
