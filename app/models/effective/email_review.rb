module Effective
  class EmailReview
    include ActiveModel::Model

    attr_accessor :email_template
    attr_accessor :template_name
    attr_accessor :body

    def self.build(attributes = {})
      new(attributes).tap do |email_review|
        email_review.body ||= email_review.email_template&.body
        email_review.template_name ||= email_review.email_template&.template_name
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
      @email_template ||= Effective::EmailTemplate.where(template_name: template_name).first
    end

  end
end
