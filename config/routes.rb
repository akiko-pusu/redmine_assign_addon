ActionController::Routing::Routes.draw do |map|
  map.connect 'assign_addon/load', :controller => 'assign_addon', :action => 'load'
end
