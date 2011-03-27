class UserObserver < ActiveRecord::Observer
  def after_create(user)
    user.create_activation_code
    Emailer.deliver_signup_notification(user) if user.errors.empty?
  end
  def after_save(user)
    Emailer.deliver_activation(user) if user.recently_activated? 
    Emailer.deliver_reset_notification(user) if user.recently_reset?
  end
end