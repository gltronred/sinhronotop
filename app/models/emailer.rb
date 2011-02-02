#require 'smtp-tls'

class Emailer < ActionMailer::Base
  def notify_event(event)
    subject = "ChGK game registration"
    @event = event
    @update_url = url_for(:controller => edit_event_path(@event))
    @disputeds_url = url_for(:controller => event_disputeds_path(@event))
    @appeals_url = url_for(:controller => event_appeals_path(@event))
    @results_url = url_for(:controller => event_results_path(@event))
    recipient =  event.user.email + ", " + event.moderator_email
    if event.moderator_email != event.user.email
       recipient += ", " + event.user.email
     end
    send(recipient, subject, event)    
  end

  def user_registred(user)
    @user = user
    send(user.email, "New user registration", user)    
  end

  def send(recipient, subject, message, sent_at = Time.now)
    @subject = subject
    @recipients = recipient
    @from = 'ChGK Sinhronotop'
    @sent_on = sent_at
    @body["title"] = subject
    @body["email"] = 'sinhronotop@googlemail.com'
    @body["message"] = message
    @headers = {}
  end  
end
