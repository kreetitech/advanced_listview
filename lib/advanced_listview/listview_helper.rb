module ListviewHelper
  def listview_sort_link(sort_field, field_name = nil, html_options = {})
    sort_field.downcase!
    field_name = field_name || sort_field.capitalize
    reverse = params[:sort] == sort_field && params[:reverse].blank?
    options = {:sort => sort_field, :per_page => params[:per_page], :offset => params[:offset]}
    options.merge!(:reverse => reverse || nil)

    # html class
    clazz = ["sortable_link", html_options[:class]]
    if params[:sort] == sort_field
      clazz << (reverse ? "sort_down" : "sort_up")
    end
    clazz = clazz.compact.join(" ")

    link_to field_name, params.merge(options), html_options.merge(:class => clazz)
  end

  def listview_search_form
    "<form action='#{url_for(params.merge(:query => nil))}' method='get' class='listview-search'>
      <input class='input-small' type='search' value='#{params[:query].presence.to_s}' placeholder='Search' name='query' style='margin-bottom:0;' />
      <input type='submit' value='Search' class='btn btn-primary'>
     </form>".html_safe
  end

  def listview_csv_export_link(options = {})
    fields = options.delete(:fields).to_a.join(",").presence
    link_to "Export CSV", url_for(params.merge(:fields => fields, :format => "csv")), options.delete(:html)
  end
end
