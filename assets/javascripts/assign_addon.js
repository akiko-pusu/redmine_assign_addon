/*
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
*/
function update_assigned_to_id(issue_id) {
  if (Prototype.Browser.IE) {
    xmlhttp = new XMLHttpRequest();
    xmlhttp.open('GET', '/assign_addon/load?issue_id=' + issue_id, true);
    xmlhttp.onreadystatechange = function ()
    {
    if (xmlhttp.readyState == 4 && xmlhttp.status == 200)
      {
        change_assigned_pulldown(xmlhttp.responseText);
      }
    };
    xmlhttp.send(null);
  }

  if (!Prototype.Browser.IE) {
    new Ajax.Updater('issue_assigned_to_id', '/assign_addon/load?issue_id=' + issue_id, {asynchronous:true, evalScripts:true});
  }
}

function change_assigned_pulldown(str) { 
  document.getElementById('issue_assigned_to_id').innerHTML = '' + str;
  document.getElementById('issue_assigned_to_id').outerHTML = document.getElementById('issue_assigned_to_id').innerHTML;
}
