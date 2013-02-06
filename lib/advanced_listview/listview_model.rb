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
                         else
                           []
                         end.collect { |field| "#{self.table_name}.#{field}"}
    @includes = []
    if options.has_key?(:include)
      options[:include].each do |model_name, fields|
        @includes << model_name
        fields.each do |field|
          @searchable_fields << "#{model_name.to_s.capitalize.constantize.table_name}.#{field.to_s}"
        end
      end
    end
  end

  # use will_paginate gem for pagination
  def get_sorted_collection(order, page, per_page, query = nil, filters = nil)
    scope = self
    scope = scope.includes(@includes).where(query_conditions(query)) if query
    scope = scope.where(filter_conditions(filters)) if filters

    # allow order param like table_name.fieldname
    order = order.split(".")
    table = if order.size > 1 && self.method_defined?(order.first)
              order.first
            else
              self.table_name
            end
    attr = self.method_defined?(order.last.split.first) ? order.last : "id"
    order = "#{table}.#{attr}"

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
      @searchable_fields.each do |field|
        cond << "#{field} like '%#{query}%'"
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

