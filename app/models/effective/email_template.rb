module Effective
  class EmailTemplate < ActiveRecord::Base
    self.table_name = (EffectiveEmailTemplates.email_templates_table_name || :email_templates).to_s

    attr_accessor :current_user

    log_changes if respond_to?(:log_changes)

    CONTENT_TYPE_PLAIN = 'text/plain'
    CONTENT_TYPE_HTML = 'text/html'
    CONTENT_TYPES = [CONTENT_TYPE_PLAIN, CONTENT_TYPE_HTML]

    effective_resource do
      template_name     :string
      content_type      :string

      subject           :string
      from              :string
      cc                :string
      bcc               :string
      body              :text

      timestamps
    end

    before_validation do
      self.content_type ||= CONTENT_TYPES.first
      self.from ||= EffectiveEmailTemplates.mailer_froms.first
    end

    validates :body, liquid: true
    validates :subject, liquid: true

    validates :subject, presence: true
    validates :from, presence: true, email: true
    validates :body, presence: true
    validates :content_type, presence: true, inclusion: { in: CONTENT_TYPES }
    validates :template_name, presence: true

    validate(if: -> { html? && body.present? }) do
      errors.add(:body, 'expected html tags in body') unless body.include?('</p>') || body.include?('</div>')
    end

    validate(if: -> { plain? && body.present? }) do
      errors.add(:body, 'expected no html tags in body') if body.include?('</p>') || body.include?('</div>')
    end

    def to_s
      template_name.presence || 'New Email Template'
    end

    def html?
      content_type == CONTENT_TYPE_HTML
    end

    def plain?
      content_type == CONTENT_TYPE_PLAIN
    end

    def render(assigns = {})
      assigns = deep_stringify_assigns(assigns)

      {
        from: from,
        cc: cc.presence,
        bcc: bcc.presence,
        content_type: content_type,
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
      Liquid::Template.parse(body)
    end

    def template_subject
      Liquid::Template.parse(subject)
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
