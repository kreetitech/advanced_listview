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

  # use will_paginate gem for pagination
  def get_sorted_collection(sort, reverse, page, per_page, query = nil, filters = nil)
    scope = self
    scope = scope.where(query_conditions(query)) if query
    scope = scope.where(filter_conditions(filters)) if filters

    order = "#{self.table_name}.#{sort}"
    order << " desc" if reverse

    if per_page
      # using will_paginate
      total = scope.count
      current_page = [page.to_i, 1].max
      offset = [0, page.to_i - 1].max * per_page

      collection = scope.limit(per_page).offset(offset).order(order)
      results = WillPaginate::Collection.create(current_page, per_page, total) do |pager|
        pager.replace(collection)
      end
    else
      scope.order(order)
    end
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

