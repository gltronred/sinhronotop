class EventObserver < ActiveRecord::Observer
  def after_save(event)
    Emailer.deliver_notify_event(event)
  end
end