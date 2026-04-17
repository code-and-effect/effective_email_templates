class CreateEffectiveEmailTemplates < ActiveRecord::Migration[6.0]
  def change
    create_table :email_templates do |t|
      t.string    :template_name

      t.string    :subject
      t.string    :from
      t.string    :bcc
      t.string    :cc

      t.text      :body

      t.timestamps
    end
  end
end

