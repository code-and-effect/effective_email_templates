class CreateEffectiveEmailTemplates < ActiveRecord::Migration
  def self.up
    create_table :email_templates do |t|
      t.string :subject,  :null => false
      t.string :from,     :null => false
      t.string :bcc
      t.string :cc
      t.text :body,       :null => false
      t.text :template,   :null => false
    end
  end

  def self.down
    drop_table :email_templates
  end
end

