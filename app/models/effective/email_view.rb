module Effective
  class EmailView
    include ActiveModel::Model

    attr_accessor :template_name
    attr_accessor :body

    def self.build(attributes = {})
      new().tap do |view|
        view.assign_attributes(attributes)

        if view.template_name.present?
          view.body ||= view.email_template.body
        end
      end
    end

    validates :body, presence: true

    validate(if: -> { body.present? }) do
      begin
        Liquid::Template.parse(body)
      rescue Liquid::SyntaxError => e
        errors.add(:body, e.message)
      end
    end

    def email_template
      @email_template ||= Effective::EmailTemplate.where(template_name: template_name).first!
    end

  end
end
