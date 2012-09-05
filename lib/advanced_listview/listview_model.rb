module ListviewModel
  # mention the searchabe fields in the model as
  # listview_search :only => [:name, :address] ### using :only
  # listview_search :except => [:name, :address] ### using :except
  def listview_search(options = {})
    raise "Invalid search field options" if options[:only].blank? && options[:except].blank?
    @searchable_fields = if options.has_key?(:only)
                           options[:only]
                         elsif options.has_key?(:except)
                           self.column_names - options[:except].collect(&:to_s)
                         end
  end

  def searchable_fields
    raise "Please mention default searchable fields for #{self.name} model!" unless @searchable_fields
    @searchable_fields.collect(&:to_s)
  end

  def get_sorted_collection(sort, reverse, per_page, offset, query = nil, filters = nil)
    scope = self
    scope = scope.where(query_conditions(query)) if query
    scope = scope.where(filter_conditions(filters)) if filters

    order = "#{self.table_name}.#{sort}"
    order << " desc" if reverse

    scope.order(order).limit(per_page).offset(offset)
  end

  private

  def query_conditions(query)
    [].tap do |cond|
      searchable_fields.each do |field|
        cond << "#{self.table_name}.#{field} like '%#{query}%'"
      end
    end.join(" OR ")
  end

  # filters example => {"filters"=>{"active"=>"true", "published" => true}}
  def filter_conditions(filters)
    col_names = self.column_names
    [].tap do |f|
      filters.each do |field_name, val|
        next unless col_names.include?(field_name)
        f << "#{self.table_name}.#{field_name} = '#{val}'"
      end
    end.join(" AND ")
  end
end

