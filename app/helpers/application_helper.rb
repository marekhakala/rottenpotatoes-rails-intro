module ApplicationHelper
  def is_rating_checked? rating
    return true if session[:ratings] and session[:ratings].include?(rating)
    false
  end
end
