require 'csv'
require 'will_paginate'
require "advanced_listview/version"
require "advanced_listview/listview_model"
require "advanced_listview/listview_controller"
require "advanced_listview/listview_helper"
require "advanced_listview/bootstrap_will_paginate"

class ActiveRecord::Base
  extend ListviewModel
end

class ActionController::Base
  include ListviewController
  helper ListviewHelper
end
