# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def eu_date(date)
    date.strftime('%d.%m.%Y')
  end
end
