module Effective
  class EmailReview
    include ActiveModel::Model

    attr_accessor :email_template
    attr_accessor :template_name

    attr_accessor :body
    attr_accessor :subject
    attr_accessor :from
    attr_accessor :cc
    attr_accessor :bcc

    def self.build(attributes = {})
      email_review = new(attributes)
      template = email_review.email_template

      if template.present?
        email_review.body ||= template.body
        email_review.subject ||= template.subject
        email_review.from ||= template.from
        email_review.cc ||= template.cc
        email_review.bcc ||= template.bcc
        email_review.template_name ||= template.template_name
      end

      email_review
    end

    validates :body, presence: true, liquid: true
    validates :subject, liquid: true

    def email_template
      @email_template ||= Effective::EmailTemplate.where(template_name: template_name).first
    end

  end
end
