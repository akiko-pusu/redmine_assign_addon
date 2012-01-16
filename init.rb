require 'redmine'
require 'dispatcher'
require 'assign_hooks'

Redmine::Plugin.register :redmine_assign_addon do
  name 'Redmine Assign Addon plugin'
  author 'Akiko Takano'
  description 'This is plug-in aiming to support selecting a user to be assigned.'
  version '0.0.1'
  url 'https://github.com/akiko-pusu/redmine_assign_addon'

  requires_redmine :version_or_higher => '1.3.0'

  settings :partial => 'settings/redmine_assign_addon',
    :default => {
      'enable' => 'true',
      'exclude_locked_user' => 'true'
    }

end

Dispatcher.to_prepare do
  # File encoding for attachments.
  require_dependency 'application_helper'
end
