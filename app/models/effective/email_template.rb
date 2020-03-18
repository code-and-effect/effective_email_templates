module Effective
  class EmailTemplate < ActiveRecord::Base
    self.table_name = EffectiveEmailTemplates.email_templates_table_name.to_s

    CONTENT_TYPES = ['text/plain', 'text/html']

    serialize :template_body, Liquid::Template
    serialize :template_subject, Liquid::Template
    serialize :template_variables, Array

    # Attributes
    # subject           :string
    # from              :string
    # cc                :string
    # bcc               :string
    # body              :text
    # content_type      :string
    #
    # template_name       :string
    # template_body       :text
    # template_subject    :text
    # template_variables  :text
    #
    # timestamps

    before_validation do
      self.template_name ||= subject.to_s.parameterize
      self.content_type ||= CONTENT_TYPES.first
    end

    before_validation(if: -> { body.present? }) do
      begin
        self.template_body = Liquid::Template.parse(body)
      rescue Liquid::SyntaxError => e
        errors.add(:body, e.message)
      end
    end

    before_validation(if: -> { subject.present? }) do
      begin
        self.template_subject = Liquid::Template.parse(subject)
      rescue Liquid::SyntaxError => e
        errors.add(:subject, e.message)
      end
    end

    validates :subject, presence: true
    validates :from, presence: true
    validates :body, presence: true
    validates :content_type, presence: true, inclusion: { in: CONTENT_TYPES }

    validates :template_name, presence: true
    validates :template_body, presence: true
    validates :template_subject, presence: true

    before_save do
      self.template_variables = find_template_variables
    end

    def to_s
      template_name.presence || 'New Email Template'
    end

    def render(assigns = {})
      assigns = assigns.deep_stringify_keys() if assigns.respond_to?(:deep_stringify_keys)

      {
        from: from,
        cc: cc.presence || false,
        bcc: bcc.presence || false,
        content_type: content_type,
        subject: template_subject.render(assigns),
        body: template_body.render(assigns)
      }
    end

    private

    def find_template_variables
      [template_body.presence, template_subject.presence].compact.map do |template|
        Liquid::ParseTreeVisitor.for(template.root).add_callback_for(Liquid::VariableLookup) do |node|
          [node.name, *node.lookups].join('.')
        end.visit
      end.flatten.uniq.compact
    end

  end

end
