module EffectiveEmailTemplatesHelper

  def effective_email_review_fields(form, template_name)
    email_review = form.object.email_review

    unless email_review&.template_name == template_name.to_s
      email_template = Effective::EmailTemplate.where(template_name: template_name).first!
      email_review = Effective::EmailReview.build(email_template: email_template)
    end

    render(partial: 'effective/email_reviews/fields', locals: { email_review: email_review, form: form })
  end

end
