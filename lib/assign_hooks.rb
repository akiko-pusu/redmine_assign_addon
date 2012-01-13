class AssignHooks < Redmine::Hook::ViewListener
  def view_issues_form_details_bottom(context ={})
    return '' unless Setting.plugin_redmine_assign_addon['enable'] == "true"
    return '' unless context[:issue]
    issue = context[:issue]
    project = context[:project]
    o = ''
    o << '<script type="text/javascript">'
    o << 'new Ajax.Updater('
    o << "'issue_assigned_to_id', '/assign_addon/load?issue_id=#{issue.id}', {asynchronous:true, evalScripts:true}); "
    o << '</script>'
    return o
  end
end
