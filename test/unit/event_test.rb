require 'test_helper'
require 'unit/unit_test_helper'

class EventTest < ActiveSupport::TestCase
  include UnitTestHelper

  def test_create_and_edit_event
    
    event = Event.create(:game => games(:bb2),
    :city => cities(:cologne),
    :event_status => EventStatus.find_by_short_name("new"),
    :user => users(:trodor),
    :moderator_name => "Василий Пупкин",
    :moderator_email => 'pupkin@vasi.net',
    :last_change => "заявка получена и будет рассмотрена",
    :game_time => "13:30",
    :date => Date.today + 1.day)
    event.save!
    check_email(['riga@example.com', "pupkin@vasi.net"], 
    ["Дмитрий Бочаров", "Кельн", "Василий Пупкин", "pupkin@vasi.net", (Date.today + 1.day).loc, "новая", "заявка получена и будет рассмотрена", "13:30"], 
    ["принимаюся", "Латвия"])

    event.update_attributes(:moderation => users(:knop),
    :moderator_name => nil,
    :moderator_email => nil,
    :more_info => "Хотим играть в субботу",
    :last_change => "данные заявки изменены",
    :game_time => "13:00")
    check_email(['riga@example.com', "kupr@example.com"], 
    ["Дмитрий Бочаров", "Кельн", "Константин Кноп", "kupr@example", (Date.today + 1.day).loc, "новая", "данные заявки изменены", "Хотим играть в субботу", "13:00"], 
    ["принимаюся", "Латвия", "Василий Пупкин", "pupkin@vasi.net"])    

    event.update_attributes(:event_status => EventStatus.find_by_short_name("approved"))
    check_email(['riga@example.com', "kupr@example.com"], ["Спорные ответы принимаются до", "Апелляции принимаются до", "Результаты принимаются до", "принята"])    

    event.update_attributes(:event_status => EventStatus.find_by_short_name("denied"))
    check_email(['riga@example.com', "kupr@example.com"], ["отклонена"],  ["принимаюся"])
  end


end
