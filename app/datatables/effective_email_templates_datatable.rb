class EffectiveEmailTemplatesDatatable < Effective::Datatable
  datatable do
    order :subject, :asc
    length :all

    col :updated_at, visible: false
    col :created_at, visible: false
    col :id, visible: false

    col :template_name, label: 'Name'

    col :from do |email_template|
      html_escape(email_template.from)
    end

    col :cc do |email_template|
      html_escape(email_template.cc)
    end

    col :bcc do |email_template|
      html_escape(email_template.bcc)
    end

    col :subject

    col :body do |email_template|
      simple_format(email_template.body)
    end

    col :content_type, visible: false

    actions_col
  end

  collection do
    Effective::EmailTemplate.all
  end
end
