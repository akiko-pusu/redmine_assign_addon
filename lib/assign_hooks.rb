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
    project = context[:project]
    o = ''
    o << '<script type="text/javascript">'
    o << "if (Prototype.Browser.IE) {"
    o << "  xmlhttp = new XMLHttpRequest();"
    o << "  xmlhttp.open('GET', '/assign_addon/load?issue_id=#{issue.id}', true);"
    o << "  xmlhttp.onreadystatechange = function ()"
    o << "  {"
    o << "    if (xmlhttp.readyState == 4 && xmlhttp.status == 200)"
    o << "    {"
    o << "      change_assigned_pulldown(xmlhttp.responseText);"
    o << "    }"
    o << "  };"
    o << "  xmlhttp.send(null);"
    o << "} "
    o << "if (!Prototype.Browser.IE) {"
    o << "  new Ajax.Updater('issue_assigned_to_id', '/assign_addon/load?issue_id=#{issue.id}', {asynchronous:true, evalScripts:true}); "
    o << "}"
    o << ""  
    o << "function change_assigned_pulldown(str) { "
    o << "  document.getElementById('issue_assigned_to_id').innerHTML = '' + str;"
    o << "  document.getElementById('issue_assigned_to_id').outerHTML = document.getElementById('issue_assigned_to_id').innerHTML;"
    o << "}"
    o << "</script>"
    return o
  end
end
