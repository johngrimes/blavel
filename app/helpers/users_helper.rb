module UsersHelper
  
  # Returns the full name of a user, taking into account that a user may not
  # have entered both first name and surname.
  def user_full_name(user)
    if !user.first_name.blank? and !user.surname.blank?
      
      # If both names are present, return full name
      user.first_name + ' ' + user.surname
    elsif !user.first_name.blank? and user.surname.blank?
      
      # If only the first name was entered, only return the first name
      user.first_name
    else
      
      # Otherwise, just return the surname
      user.surname
    end
  end
end