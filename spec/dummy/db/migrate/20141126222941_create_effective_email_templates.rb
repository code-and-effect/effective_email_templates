class CreateEffectiveEmailTemplates < ActiveRecord::Migration
  def self.up
    create_table :email_templates do |t|
      t.string :subject
      t.string :from
      t.string :bcc
      t.string :cc
      t.string :slug,     :null => false
      t.text :body,       :null => false
      t.text :template,   :null => false
    end

    add_index :email_templates, :slug
  end

  def self.down
    drop_table :email_templates
  end
end

