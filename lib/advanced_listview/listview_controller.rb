module ListviewController
  # to export csv, just add a .csv as extension, send comma separated pparams[:fields] for selective fields
  # example params[:fields] = "id,name,address1"
  def get_sorted(arel, options = {})
    sort = params[:sort].presence || "id"
    reverse = params[:reverse].presence
    query = params[:query].presence
    filters = params[:filters].presence

    # pagination options
    per_page = options[:per_page].presence
    page = options[:page].presence

    records = arel.get_sorted_collection(sort, reverse, page, per_page, query, filters)

    respond_to do |format|
      format.html { records}
      format.csv { export_csv(records)}
      format.json { render :json => records}
    end
  end

  def export_csv(records)
    fields = if params[:fields].present?
               params[:fields].split(",")
             else
               records.first.class.column_names
             end
    out = CSV.generate do |csv|
      csv << fields
      records.each do |record|
        row = []
        fields.collect { |f| row << record.try(f)}
        csv << row
      end
    end
    filename = [records.first.class.name.downcase, Date.today.strftime("%m_%d_%Y")].join("_")
    send_data out, :type => 'header=present', :disposition => "attachment;", :filename => "#{filename}.csv"
  end
end

