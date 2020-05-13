module ApplicationHelper
  def active?(path)
    "active" if current_page?(path)
  end

  def viewer_or_partner(viewer, user)
    if viewer == user
      "You"
    else
      link_to "#{user.username}", user_path(user.id)
    end
  end
end
