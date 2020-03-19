# HasOneEmailReview
# Allows any model to easily review an email template and make changes to the body

module HasOneEmailReview
  extend ActiveSupport::Concern

  module ActiveRecord
    def has_one_email_review
      include ::HasOneEmailReview
    end
  end

  included do
    attr_accessor :email_review

    validate(if: -> { email_review.present? }) do
      self.errors.add(:base, 'reviewed email is invalid') unless email_review.valid?
    end
  end

  def build_email_review(atts = {})
    self.email_review ||= Effective::EmailReview.build(atts)
  end

  def email_review_attributes=(atts)
    self.email_review = Effective::EmailReview.new(atts)
  end

end

