class EventObserver < ActiveRecord::Observer
  def before_create(event)
    event.event_status = EventStatus.find_by_short_name("new")
  end
  
  def after_save(event)
    Emailer.deliver_notify_event(event)
  end
  
  def after_validation_on_create(event)
    event.last_change = "Заявка получена и будет рассмотрена."
  end
  
  def after_validation_on_update(event)
    status_new = EventStatus.find_by_short_name('new')
    event.last_change = "Данные заявки изменены."
    if event.event_status != status_new
      event.event_status = status_new
      event.last_change << " Важно: при изменении данных заявки она автоматически приобретает статус 'новая' и требует (повторного) рассмотрения."
    end
  end
end