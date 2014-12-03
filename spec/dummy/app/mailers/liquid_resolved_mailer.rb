class LiquidResolvedMailer < ActionMailer::Base
  def test_email
    @noun = 'resolution'
    mail(to: 'some_bloke@example.com')
  end
end

