class EffectiveEmailTemplatesDatatable < Effective::Datatable
  datatable do
    order :subject, :asc
    length :all

    col :updated_at, visible: false
    col :created_at, visible: false
    col :id, visible: false

    col :subject
    col :from
    col :cc
    col :bcc
    col :body

    actions_col partial: '/admin/email_templates/actions', partial_as: 'email_template'
  end

  collection do
    Effective::EmailTemplate.all
  end
end

