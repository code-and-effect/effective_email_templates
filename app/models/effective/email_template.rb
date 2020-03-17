module Effective
  class EmailTemplate < ActiveRecord::Base

    self.table_name = EffectiveEmailTemplates.email_templates_table_name.to_s

    # Attributes
    # name              :string
    # subject           :string
    # from              :string
    # cc                :string
    # bcc               :string
    # body              :text
    # timestamps

    before_validation do
      self.name ||= subject.to_s.parameterize
    end

    validates :name, presence: true
    validates :subject, presence: true
    validates :from, presence: true
    validates :body, presence: true

    def to_s
      subject || 'New Email Template'
    end

  end

end
