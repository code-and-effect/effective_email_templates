module EffectiveEmailTemplatesHelper

  def effective_email_review_fields(form, template_name)
    email_review = form.object.email_review

    email_review ||= begin
      email_template = Effective::EmailTemplate.where(template_name: template_name).first!
      form.object.build_email_review(email_template: email_template)
    end

    render(partial: 'effective/email_reviews/fields', locals: { email_review: email_review, form: form })
  end

end
