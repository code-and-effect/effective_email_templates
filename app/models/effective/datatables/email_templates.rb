if defined?(EffectiveDatatables)
  module Effective
    module Datatables
      class EmailTemplates < Effective::Datatable
        table_column :id

        def collection
          Effective::EmailTemplate.all
        end

      end
    end
  end
end
