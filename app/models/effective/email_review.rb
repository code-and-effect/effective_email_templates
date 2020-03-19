module Effective
  class EmailReview
    include ActiveModel::Model

    attr_accessor :email_template
    attr_accessor :body

    def self.build(attributes = {})
      new(attributes).tap do |email_review|
        email_review.body ||= email_review.email_template&.body
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

  end
end
