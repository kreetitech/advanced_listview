# AdvancedListview

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'advanced_listview', :git => "git://github.com/kreetitech/advanced_listview.git"

And then execute:

    $ bundle

## Basic Usage
    ## perform a basic query
    @posts = get_sorted Post
    
    ## or perform a paginated query
    @posts = get_sorted(Post, :page => params[:page], :per_page => 30)
    
    ## render page links in the view
    <%= will_paginate @posts %>
    
    ## render page links in the view, for bootstrap
    <%= bootstrap_will_paginate @posts %>
    
    ## configure searchable fields in the model
    listview_search :only => [:title]
    
    ## or you can use except
    listview_search :except => [:id, :created_at, :updated_at]
    
    ## search form in the list view (search renders the same page the method being used for list)
    <%= listview_search_form %>
    
    ## csv export link, from the list page
    <%= listview_csv_export_link %>
    
    ## sortable column header, database attribute name and link name same
    <%= listview_sort_link "name" %>

    ## sortable column header, database attribute name and link name different
    <%= listview_sort_link "name", "Title" %>
    
    ## filters params example => {"filters"=>{"active"=>"true", "published" => true}}

This gem adds sorting, searching, filtering and csv export features.    

TODO: Write usage instructions here

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
