class UserObserver < ActiveRecord::Observer
  def after_create(user)
    Emailer.deliver_user_registred user
  end
  def after_save(user)
    Emailer.deliver_reset_notification(user) if user.recently_reset?
  end
end