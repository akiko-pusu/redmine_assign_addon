# Assign Addon plugin for Redmine
# Copyright (C) 2012 Akiko Takano
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
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
