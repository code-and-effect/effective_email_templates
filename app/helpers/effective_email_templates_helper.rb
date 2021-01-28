module EffectiveEmailTemplatesHelper

  # We are given a form to essentially send an email
  def effective_email_review_fields(form, template_name, mail = nil)
    raise('expected a mail object') if mail && !mail.kind_of?(ActionMailer::MessageDelivery)
    raise('expected form.object to respond to email_review') unless form.object.respond_to?(:email_review)

    email_review = form.object.email_review

    unless email_review&.template_name == template_name.to_s
      email_template = Effective::EmailTemplate.where(template_name: template_name).first!
      email_review = Effective::EmailReview.build(email_template: email_template)

      if mail.present?
        email_review.body = mail.message.body
        email_review.subject = mail.message.subject
      end
    end

    render(partial: 'effective/email_reviews/fields', locals: { email_review: email_review, form: form })
  end

end
