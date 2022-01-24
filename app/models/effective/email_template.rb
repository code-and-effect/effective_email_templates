module Effective
  class EmailTemplate < ActiveRecord::Base
    self.table_name = EffectiveEmailTemplates.email_templates_table_name.to_s

    attr_accessor :current_user

    log_changes if respond_to?(:log_changes)

    CONTENT_TYPES = ['text/plain', 'text/html']

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
    end

    validates :body, liquid: true
    validates :subject, liquid: true

    validates :subject, presence: true
    validates :from, presence: true, email: true
    validates :body, presence: true
    validates :content_type, presence: true, inclusion: { in: CONTENT_TYPES }
    validates :template_name, presence: true

    # validate(if: -> { content_type == 'text/html' && body.present? }) do
    #   unless body.include?('<') && body.include?('>')
    #     self.errors.add(:content_type, 'expected html tags in body')
    #     self.errors.add(:body, 'expected html tags in body')
    #   end
    # end

    # validate(if: -> { content_type == 'text/plain' && body.present? }) do
    #   if body.include?('</a>') || body.include?('</p>')
    #     self.errors.add(:content_type, 'expected no html tags in body')
    #     self.errors.add(:body, 'expected no html tags in body')
    #   end
    # end

    def to_s
      template_name.presence || 'New Email Template'
    end

    def render(assigns = {})
      assigns = deep_stringify_assigns(assigns)

      result = {
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
