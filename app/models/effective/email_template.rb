module Effective
  class EmailTemplate < ActiveRecord::Base
    include ActionView::Helpers::TextHelper

    self.table_name = (EffectiveEmailTemplates.email_templates_table_name || :email_templates).to_s

    attr_accessor :current_user

    log_changes if respond_to?(:log_changes)

    effective_resource do
      template_name     :string

      from              :string
      cc                :string
      bcc               :string

      subject           :string
      body              :text

      timestamps
    end

    before_validation do
      self.from ||= EffectiveEmailTemplates.mailer_froms.first
    end

    # Convert to HTML
    before_validation(if: -> { body_plain? }) do
      html = simple_format(body)

      # Replace [UpsideAMS](http://www.upsideams.com) type markdown links
      html = html.gsub(/\[(.*?)\]\((.*?)\)/, '<a href="\2">\1</a>')

      assign_attributes(body: html)
    end

    # A non-breaking space inside a Liquid tag - e.g. "{{ reason }}" pasted or round-tripped through
    # a WYSIWYG editor as "{{ reason }}" - stops Liquid from parsing the variable, so it renders
    # blank instead of its value. Normalize any &nbsp; entity or U+00A0 char that lands INSIDE a
    # {{ }} / {% %} tag back to a regular space. Runs before the liquid validation so the cleaned
    # value is what gets parsed, stored, and imported.
    before_validation do
      self.body = strip_liquid_nbsp(body)
      self.subject = strip_liquid_nbsp(subject)
    end

    validates :body, liquid: true
    validates :subject, liquid: true

    validates :subject, presence: true
    validates :from, presence: true, email: true
    validates :body, presence: true
    validates :template_name, presence: true

    validate(if: -> { body.present? }) do
      errors.add(:body, 'expected html tags in body') if body_plain?
    end

    def to_s
      template_name.presence || 'New Email Template'
    end

    def content_type
      'text/html'
    end

    def body_plain?
      body.present? && !(body.include?('</p>') || body.include?('</div>'))
    end

    LIQUID_TAG = /\{\{.*?\}\}|\{%.*?%\}/m
    NBSP = /\u00A0|&nbsp;/

    # Replace non-breaking spaces with regular spaces, but only INSIDE Liquid tags (where they break
    # parsing). Intentional &nbsp; elsewhere in the template's HTML is left untouched.
    def strip_liquid_nbsp(value)
      return value if value.blank?
      value.gsub(LIQUID_TAG) { |tag| tag.gsub(NBSP, ' ') }
    end

    def render(assigns = {})
      assigns = deep_stringify_assigns(assigns)

      {
        from: from,
        cc: cc.presence,
        bcc: bcc.presence,
        subject: template_subject.render(assigns),
        body: template_body.render(assigns)
      }.compact
    end

    def template_variables
      [template_body.presence, template_subject.presence].compact.map do |template|
        Liquid::ParseTreeVisitor.for(template.root).add_callback_for(Liquid::VariableLookup) do |node|
          [node.name, *node.lookups].join('.')
        end.visit
      end.flatten.uniq.compact
    end

    private

    def template_body
      (Liquid::Template.parse(body) rescue nil)
    end

    def template_subject
      (Liquid::Template.parse(subject) rescue nil)
    end

    def deep_stringify_assigns(assigns)
      if assigns.respond_to?(:deep_stringify_keys!)
        assigns.deep_stringify_keys!
      end

      if assigns.respond_to?(:deep_transform_values!)
        assigns.deep_transform_values! do |value|
          value.kind_of?(ActiveRecord::Base) ? value.to_s : value
        end
      end

      assigns
    end

  end

end
