module ApplicationHelper
  def active?(path)
    "active" if current_page?(path)
  end
  
  def tab_active?(path)
    no_path = path.delete_suffix("_path")
    "active" if (/#{no_path}\/\d+$/i === request.fullpath) || (active?(path) == "active")
  end

  def viewer_or_partner(viewer, user)
    if viewer == user
      "You"
    else
      link_to "#{user.username}", user_path(user.id)
    end
  end
end
