# An ActiveRecord validator for any liquid field that you would use with effective_email_templates or otherwise
#
# validates :body, liquid: true

class LiquidValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if value.present?
      begin
        Liquid::Template.parse(value)
      rescue Liquid::SyntaxError => e
        record.errors.add(attribute, e.message)
      end
    end
  end
end
