class EffectiveEmailTemplatesDatatable < Effective::Datatable
  datatable do
    order :subject, :asc
    length :all

    col :updated_at, visible: false
    col :created_at, visible: false
    col :id, visible: false

    col :template_name, label: 'Name'

    col :from, search: EffectiveEmailTemplates.mailer_froms do |email_template|
      ERB::Util.html_escape_once(email_template.from)
    end

    col :cc
    col :bcc
    col :subject
    col :body

    col :content_type, visible: false

    actions_col
  end

  collection do
    Effective::EmailTemplate.all
  end
end
