module EffectiveEmailTemplatesTestBuilder

  def build_effective_email_template
    Effective::EmailTemplate.new(
      template_name: 'welcome',
      subject: 'Welcome {{ user.first_name }} {{ user.last_name }}',
      body: "<p>Welcome {{ user.first_name }} {{ user.last_name }}</p>\n\n<p>Have a great day!</p>"
    )
  end

  def create_user!
    build_user.tap { |user| user.save! }
  end

  def build_user
    @user_index ||= 0
    @user_index += 1

    User.new(
      email: "user#{@user_index}@example.com",
      password: 'rubicon2020',
      password_confirmation: 'rubicon2020',
      first_name: 'Test',
      last_name: 'User'
    )
  end

end
