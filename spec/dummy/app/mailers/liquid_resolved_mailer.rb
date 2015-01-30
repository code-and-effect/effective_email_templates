class LiquidResolvedMailer < Effective::LiquidMailer
  def test_email( liquid_options = nil )
    @to_liquid = liquid_options || {
      'noun' => 'resolution'
    }
    mail(to: 'some_bloke@example.com')
  end
end

