require 'csv'
require "advanced_listview/version"
require "advanced_listview/listview_model"
require "advanced_listview/listview_controller"
require "advanced_listview/listview_helper"


class ActiveRecord::Base
  extend ListviewModel
end

class ActionController::Base
  include ListviewController
  helper ListviewHelper
end
