require 'redmine'
require 'dispatcher'
require 'assign_hooks'

Redmine::Plugin.register :redmine_assign_addon do
  name 'Redmine Assign Addon plugin'
  author 'Akiko Takano'
  description 'This is plug-in aiming to support selecting a user to be assigned.'
  version '0.0.1'
  #url 'http://example.com/path/to/plugin'
  #author_url 'http://example.com/about'

  requires_redmine :version_or_higher => '1.2.0'

  settings :partial => 'settings/redmine_assign_addon',
    :default => {
      'enable' => 'true'
    }

end

Dispatcher.to_prepare do
  # File encoding for attachments.
  require_dependency 'application_helper'
end
