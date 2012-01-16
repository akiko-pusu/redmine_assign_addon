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
    return '<select id="issue_assigned_to_id" name="issue[assigned_to_id]"><option value=""></option></option>' if collection.empty?

    selected = issue.assigned_to
    s = ''
    groups = ''
    exclude_locked = true 
    if Setting.plugin_redmine_assign_addon['exclude_locked_user'] == "true"
      exclude_locked = true
    else 
      exclude_locked = false
    end

    logger = Rails.logger     
    logger.info "Exclude Option: #{Setting.plugin_redmine_assign_addon['exclude_locked_user']}" if logger
    logger.info "Exclude Option: #{exclude_locked}" if logger


    # override selected option
    has_selected = false
    assigned_id = issue.assigned_to_id

    # For Watching and Assignable users and Author
    both_groups = ''
    author_groups = ''

    # Get assignable Author
    author = issue.author
    #if !author.locked? && collection.include?(author)
    if collection.include?(author)

      logger.info "Author Include" if logger
      logger.info "Author Locked? #{author.locked?} " if logger
      unless exclude_locked && author.locked?
        exclude_option = ''
        select_opt = ''
        exclude_style = ''

        exclude_option = ' (Locked)' if exclude_locked != true && author.locked?
        exclude_style = ' class="user_locked"' if exclude_locked != true && author.locked?
        logger.info "Exclude option #{exclude_option}" if logger
        if is_assigned?(author, assigned_id)
          has_selected = true
          select_opt = ' selected="selected"' 
        end
        author_groups = %(<option value="#{author.id}"#{select_opt}#{exclude_style}>#{author.name}#{exclude_option}</option>)
        logger.info "Author_group: #{author_groups}" if logger
      end
      if author.locked? && exclude_locked == true
        author_groups = ''
      end 
    end
    
    unless author_groups.empty?
      author_groups = %(<optgroup label="#{l(:field_author)}">#{author_groups}</optgroup>)
    end
    #logger.info "Author_group2: #{author_groups}" if logger

    # Get both users list
    both_users = issue.assignable_users && issue.watcher_users
    both_users.sort.each do |element|
      exclude_option = ''
      select_opt = ''
      exclude_style = ''
      exclude_option = ' (Locked)' if exclude_locked != true && element.locked?
      exclude_style = ' class="user_locked"' if exclude_locked != true && element.locked?

      if is_assigned?(element, assigned_id) && has_selected == false
        has_selected = true
        select_opt = ' selected="selected"'
      end

      unless element.locked? && exclude_locked == true
        both_groups << %(<option value="#{element.id}"#{select_opt}#{exclude_style}>#{element.name}#{exclude_option}</option>)
      end
    end

    unless both_groups.empty?
      both_groups = %(<optgroup label="#{l(:label_assignable_watcher)}">#{both_groups}</optgroup>)
    end

    logger.info "Both_group: #{both_groups}" if logger

    # Wrap Default Assignable Users with optgroup
    collection.sort.each do |element|
      exclude_option = ''
      exclude_style = ''
      #exclude_option = ' (Locked)' if !element.is_a?(Group) && exclude_locked != true && element.locked?
      exclude_option = ' (Locked)' if !element.is_a?(Group) && element.locked?
      #exclude_style = ' class="user_locked"' if exclude_locked != true && element.locked?
      exclude_style = ' class="user_locked"' if element.locked?

      next if element.locked? && exclude_locked == true 

      if value_selected?(element, selected) && has_selected == false
        selected_attribute = ' selected="selected"' 
      else
        selected_attribute = ' ' 
      end

      logger.info "Check: #{element.name}" if logger

      #if !element.is_a?(Group) && !element.locked? && exclude_locked == true 
      if !element.is_a?(Group) 
        #(element.is_a?(Group) ? groups : s) << %(<option value="#{element.id}"#{selected_attribute}>#{element.name}#{exclude_option}</option>)
        s << %(<option value="#{element.id}"#{selected_attribute}#{exclude_style}>#{element.name}#{exclude_option}</option>)
      elsif element.is_a?(Group) 
        #(element.is_a?(Group) ? groups : s) << %(<option value="#{element.id}"#{selected_attribute}>#{element.name}#{exclude_option}</option>)
        groups << %(<option value="#{element.id}"#{selected_attribute}>#{element.name}#{exclude_option}</option>)
      end
    end
    unless s.empty?
      s = %(<optgroup label="#{l(:label_user_plural)}">#{s}</optgroup>)
    end

    unless groups.empty?
      groups = %(<optgroup label="#{l(:label_group_plural)}">#{groups}</optgroup>)
    end

    s = %(#{author_groups}#{both_groups}#{s}#{groups})
    s = %(<select id="issue_assigned_to_id" name="issue[assigned_to_id]"><option value=""></option>#{s}</option>)
    #logger.info "Retval: #{s}" if logger
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

  # is this user assigned?
  def is_assigned?(user, assigned_id)
    return false if assigned_id == nil
    return false if user.id != assigned_id
    return true
  end
end
