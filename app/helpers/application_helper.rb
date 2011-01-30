# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def authenticate
    render "home/index" unless logged_in?
  end
  def eu_date(date)
    date.strftime('%d.%m.%Y')
  end
end
