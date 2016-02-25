module ApplicationHelper
  def is_rating_checked? rating
    return true if session[:ratings] and session[:ratings].include?(rating)
    return true if session[:ratings].nil?
    false
  end
end
