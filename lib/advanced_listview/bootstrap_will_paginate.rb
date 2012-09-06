require 'will_paginate/view_helpers/link_renderer'
require 'will_paginate/view_helpers/action_view'

module WillPaginate
  module ActionView
    class BootstrapLinkRenderer < LinkRenderer
      protected

      def html_container(html)
        tag :div, tag(:ul, html), container_attributes
      end

      def page_number(page)
        tag :li, link(page, page, :rel => rel_value(page)), :class => ('active' if page == current_page)
      end

      def previous_or_next_page(page, text, classname)
        tag :li, link(text, page || '#'), :class => [classname[0..3], classname, ('disabled' unless page)].join(' ')
      end
    end

    def bootstrap_will_paginate(pages, options = {})
      will_paginate(pages, {:class => 'pagination', :inner_window => 2, :outer_window => 0, :renderer => BootstrapLinkRenderer, :previous_label => 'Prev'.html_safe, :next_label => 'Next'.html_safe}.merge(options))
    end
  end
end
