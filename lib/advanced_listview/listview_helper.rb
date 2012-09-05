module ListviewHelper
  def listview_sort_link(sort_field, field_name = nil)
    sort_field.downcase!
    field_name = field_name || sort_field.capitalize
    reverse = params[:sort] == sort_field && params[:reverse].blank?
    options = {:sort => sort_field, :per_page => params[:per_page], :offset => params[:offset]}
    options.merge!(:reverse => reverse || nil)
    link_to field_name, params.merge(options)
  end

  def listview_search_form
    "<form action='#{url_for(params.merge(:query => nil))}' method='get' class='listview-search'>
      <input class='input-small' type='search' value='#{params[:query].presence.to_s}' placeholder='Search' name='query' style='margin-bottom:0;' />
      <input type='submit' value='Search' class='btn btn-primary'>
     </form>".html_safe
  end

  def csv_export_link(fields = [])
    fields = fields.to_a.join(",").presence
    link_to "Export CSV", url_for(params.merge(:fields => fields, :format => "csv")), :class => "btn btn-info"
  end
end
