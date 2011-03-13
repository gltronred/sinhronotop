require 'test_helper'
require 'unit/unit_test_helper'

class EventTest < ActiveSupport::TestCase
  include UnitTestHelper

  def test_create_and_edit_event
    
    event = Event.create(:game => games(:bb2),
    :city => cities(:cologne),
    :user => users(:trodor),
    :moderator_name => "Василий Пупкин",
    :moderator_email => 'pupkin@vasi.net',
    :game_time => "13:30",
    :date => Date.today + 1.day)
    #event.save!
    check_email(['bb@example.com', 'riga@example.com', "pupkin@vasi.net"], 
    ["Дмитрий Бочаров", "Кельн", "Василий Пупкин", "pupkin@vasi.net", (Date.today + 1.day).loc, "новая", "Заявка получена и будет рассмотрена", "13:30"], 
    ["принимаюся", "Латвия"])

    event.update_attributes(:moderation => nil,
    :moderator_name => nil,
    :moderator_email => nil)
    check_email(['riga@example.com'], 
    ["Дмитрий Бочаров", "Кельн", (Date.today + 1.day).loc, "новая", "Данные заявки изменены", "13:30"], 
    ["принимаюся", "Латвия", "Василий Пупкин", "pupkin@vasi.net", "Важно"])

    event.update_attributes(:moderation => users(:knop),
    :moderator_name => nil,
    :moderator_email => nil,
    :more_info => "Хотим играть в субботу",
    :game_time => "13:00")
    check_email(['riga@example.com', "kupr@example.com"], 
    ["Дмитрий Бочаров", "Кельн", "Константин Кноп", "kupr@example.com", (Date.today + 1.day).loc, "новая", "Данные заявки изменены", "Хотим играть в субботу", "13:00"], 
    ["принимаюся", "Латвия", "Василий Пупкин", "pupkin@vasi.net", "Важно"])    

    event.update_status EventStatus.find_by_short_name("approved")
    check_email(['riga@example.com', "kupr@example.com"], 
    ["Спорные ответы принимаются до", "Апелляции принимаются до", "Результаты принимаются до", "принята"])    

    event.update_attributes(:moderation => users(:rodionov),
    :more_info => "Мы заменили ведущего")
    check_email(['bb@example.com', 'riga@example.com', "kg@example.com"], 
    ["Дмитрий Бочаров", "Кельн", "Дмитрий Родионов", "kg@example.com", "Мы заменили ведущего", "новая", "Данные заявки изменены. Важно: при изменении данных заявки она автоматически приобретает статус"], 
    ["принимаюся", "принята", "Константин Кноп", "kupr@example.com"])

    event.update_status EventStatus.find_by_short_name("denied")
    check_email(['riga@example.com', "kg@example.com"], ["отклонена"],  ["принимаюся"])
  end
  
  def test_create_and_edit_event_with_dont_know_game_options
    event = Event.create(:game => games(:kg2),
    :moderation => users(:knop),
    :user => users(:knop),
    :city => cities(:cologne),
    :date => Date.today + 1.day)
    
    event.update_status EventStatus.find_by_short_name("approved")
    
    check_email(["kupr@example.com"], 
    ["Кельн", "Константин Кноп", "kupr@example.com", (Date.today + 1.day).loc, "принята", "Статус заявки изменен"], 
    ["принимаюся"])
  end

end
