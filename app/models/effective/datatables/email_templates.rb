if defined?(EffectiveDatatables)
  module Effective
    module Datatables
      class EmailTemplates < Effective::Datatable
        table_column :id
        table_column :slug
        table_column :subject
        table_column :from
        table_column :actions, sortable: false, partial: "/admin/email_templates/actions"

        def collection
          Effective::EmailTemplate.all
        end

      end
    end
  end
end

