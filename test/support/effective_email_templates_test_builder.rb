module EffectiveEmailTemplatesTestBuilder

  def build_effective_email_template
    Effective::EmailTemplate.new(
      template_name: 'welcome',

      subject: 'Welcome {{ user.first_name }} {{ user.last_name }}',
      from: 'someone@example.com',
      body: "Welcome {{ user.first_name }} {{ user.last_name }}\r\nHave a great day!"
    )
  end

end
