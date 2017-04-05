if Gem::Version.new(EffectiveDatatables::VERSION) < Gem::Version.new('3.0')
  module Effective
    module Datatables
      class EmailTemplates < Effective::Datatable
        datatable do
          default_order :subject, :asc

          table_column :id, visible: false
          table_column :slug
          table_column :subject
          table_column :from
          table_column :cc, sortable: false, visible: false, label: 'CC'
          table_column :bcc, sortable: false, visible: false, label: 'BCC'
          table_column :body, sortable: false, visible: false
          table_column :actions, sortable: false, partial: '/admin/email_templates/actions'
        end

        def collection
          Effective::EmailTemplate.all
        end
      end
    end
  end
end
