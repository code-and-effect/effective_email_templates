module EffectiveEmailTemplatesHelper
  def datatable_of(description_of_objects, datatable)
    if datatable.nil?
      content_tag(:p, "Please use Effective Datatables gem")
    elsif datatable.collection.length > 0
      render_datatable(datatable)
    else
      content_tag(:p, "There are no email templates")
    end
  end
end

