class LiquidResolvedMailer < ActionMailer::Base
  append_view_path EffectiveEmailTemplates::LiquidResolver.new

  def test_email
    @noun = 'resolution'
    mail(to: 'some_bloke@example.com')
  end
end

