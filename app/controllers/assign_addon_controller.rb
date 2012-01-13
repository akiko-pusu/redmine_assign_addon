class AssignAddonController < ApplicationController
  unloadable
  before_filter :require_login

  # Update select(id="assigned_to_id")
  def load
    @issue = Issue.find(params[:issue_id])
    render :text => addon_options_for_select(@issue) 
  end

  #
  # private
  #
  private
  def addon_options_for_select(issue)
    collection = issue.assignable_users
    selected = issue.assigned_to
    s = ''
    groups = ''
    both = ''

    both_users = issue.assignable_users && issue.watcher_users
    both_users.sort.each do |element|
      unless element.locked?
        both << %(<option value="#{element.id}">#{element.name}</option>)
      end
    end

    unless both.empty?
      both = %(<optgroup label="#{l(:label_assignable_watcher)}">#{both}</optgroup>)
    end

    # Assignable Author
    author_group = ''
    author = issue.author
    unless author.locked? && in_array(author, issue.assignable_users)
      author_group = %(<option value="#{author.id}">#{author.name}</option>)
      author_group = %(<optgroup label="#{l(:field_author)}">#{author_group}</optgroup>)    
    end
   
    # Wrap Default Assignable Users with optgroup
    collection.sort.each do |element|
      selected_attribute = ' selected="selected"' if value_selected?(element, selected)
      (element.is_a?(Group) ? groups : s) << %(<option value="#{element.id}"#{selected_attribute}>#{element.name}</option>)
    end
    unless s.empty?
      s = %(<optgroup label="#{l(:label_user_plural)}">#{s}</optgroup>)
    end

    unless groups.empty?
      groups = %(<optgroup label="#{l(:label_group_plural)}">#{groups}</optgroup>)
    end

    s = %(#{both}#{author_group}#{s}#{groups})
    s = %(<select id="issue_assigned_to_id" name="issue[assigned_to_id]"><option value="">#{l(:label_unassigned)}</option>#{s}</option>)
    return s
  end

  # Just the same to option_value_selected. 
  def value_selected?(value, selected)
    if selected.respond_to?(:include?) && !selected.is_a?(String)
      selected.include? value
    else
      value == selected
    end
  end
end
