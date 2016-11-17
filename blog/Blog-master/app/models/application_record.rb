class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def user_full_name
    if user
      user.full_name
    else
      'Anonymous'
    end
  end

  def error_message
    error.full_messages.join(", ")
  end

end
