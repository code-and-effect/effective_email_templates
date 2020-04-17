module Effective
  class EmailTemplate < ActiveRecord::Base
    self.table_name = EffectiveEmailTemplates.email_templates_table_name.to_s

    log_changes if respond_to?(:log_changes)

    CONTENT_TYPES = ['text/plain', 'text/html']

    # Attributes
    # subject           :string
    # from              :string
    # cc                :string
    # bcc               :string
    # body              :text
    # content_type      :string
    #
    # template_name     :string
    #
    # timestamps

    before_validation do
      self.content_type ||= CONTENT_TYPES.first
    end

    before_validation(if: -> { body.present? }) do
      begin
        Liquid::Template.parse(body)
      rescue Liquid::SyntaxError => e
        errors.add(:body, e.message)
      end
    end

    before_validation(if: -> { subject.present? }) do
      begin
        Liquid::Template.parse(subject)
      rescue Liquid::SyntaxError => e
        errors.add(:subject, e.message)
      end
    end

    validates :subject, presence: true
    validates :from, presence: true
    validates :body, presence: true
    validates :content_type, presence: true, inclusion: { in: CONTENT_TYPES }
    validates :template_name, presence: true

    def to_s
      template_name.presence || 'New Email Template'
    end

    def render(assigns = {})
      assigns = deep_stringify_assigns(assigns)

      {
        from: from,
        cc: cc.presence || false,
        bcc: bcc.presence || false,
        content_type: content_type,
        subject: template_subject.render(assigns),
        body: template_body.render(assigns)
      }
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
