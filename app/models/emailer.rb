require 'smtp-tls'

class Emailer < ActionMailer::Base
  def notify_event(event)
    subject = "ChGK game registration"
    @event = event
    @action = event.new_record? ? 'создана' : 'изменена' 
    @update_url = url_for (:controller => edit_event_path(@event))
    @disputeds_url = url_for (:controller => event_disputeds_path(@event))
    @appeals_url = url_for (:controller => event_appeals_path(@event))
    @results_url = url_for (:controller => event_results_path(@event))

    recipient =  event.game.tournament.org_email + ", " + event.moderator_email
    if event.moderator_email != event.resp_email
       recipient += ", " + event.resp_email
     end
    send(recipient, subject, event)    
  end

  def send(recipient, subject, message, sent_at = Time.now)
    @subject = subject
    @recipients = recipient
    @from = 'ChGK Results'
    @sent_on = sent_at
    @body["title"] = subject
    @body["email"] = 'ckgkresults@googlemail.com'
    @body["message"] = message
    @headers = {}
  end  
end
