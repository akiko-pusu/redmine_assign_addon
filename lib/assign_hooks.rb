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
class AssignHooks < Redmine::Hook::ViewListener
  def view_layouts_base_html_head(context = {})
    return '' unless Setting.plugin_redmine_assign_addon['enable'] == "true"
    o = stylesheet_link_tag('assign_addon', :plugin => 'redmine_assign_addon')
    return o
  end

  def view_issues_form_details_bottom(context ={})
    return '' unless Setting.plugin_redmine_assign_addon['enable'] == "true"
    return '' unless context[:issue]
    issue = context[:issue]
    return '' if issue.new_record?
    o = ''

    o << javascript_include_tag('assign_addon', :plugin => 'redmine_assign_addon')
    o << '<script type="text/javascript">'
    o << "  update_assigned_to_id(#{issue.id});"
    o << "</script>"
    return o
  end
end
