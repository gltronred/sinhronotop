class Emailer < ActionMailer::Base
  
  def signup_notification(user)
    #@user = user
    @body[:url]  = "#{url_for(:controller => home_path)}activate/#{user.activation_code}"
    @body[:user] = user
    send(user.email, "New user registration")
  end

  def notify_event(event)
    subject = "ChGK game registration"
    @event = event
    @action = @event.last_change
    @update_url = url_for(:controller => edit_event_path(@event))
    @disputeds_url = url_for(:controller => event_disputeds_path(@event))
    @appeals_url = url_for(:controller => event_appeals_path(@event))
    @results_url = url_for(:controller => event_results_path(@event))
    recipient = [event.user.email, event.get_moderator_email].uniq.join(', ')
    send(recipient, subject)
  end

  def error_notification(name, email, text)
    @body[:name] = name
    @body[:submitter_email] = email
    @body[:text] = text
    send('sinhronotop@googlemail.com', "error notification")
  end
  
  def reset_notification(user)
    @subject    = 'Link to reset your password'
    @body[:url]  = "#{url_for(:controller => home_path)}reset/#{user.reset_code}"
    @body[:user] = user
    send(user.email, 'Link to reset your password')
  end

  protected

  def send(recipient, subject, sent_at = Time.now)
    @subject = subject
    @recipients = recipient
    @from = 'ChGK Sinhronotop'
    @sent_on = sent_at
    @body["title"] = subject
    @body["email"] = 'sinhronotop@googlemail.com'
    @headers = {}
  end
end
