require 'test_helper'
require 'integration/integration_test_helper'

class EventTest < ActionController::IntegrationTest
  include IntegrationTestHelper

  def test_resp_registers
    bb2 = games(:bb2)
    do_with_users([:trodor]) {
      visit "/games/#{bb2.id}"
      date = Date.today
      click_link "Зарегистрироваться"
      select_date("event_date", date.day, date.month, date.year)
      fill_in "event_moderator_name", :with => 'Вася Пупкин'
      fill_in "event_moderator_email", :with => 'pupkin@vasi.net'
      fill_in "event_more_info", :with => 'Будем играть голыми'
      fill_in "event_game_time", :with => '12:00'
      fill_in "event_num_teams", :with => '19'
      select 'Рига', :from => "event_city_id"
      click_button "Сохранить"

      assert_contain_multiple ["Спасибо, заявка получена и будет рассмотрена", "Вася Пупкин", "Рига", "pupkin@vasi.net", "Дмитрий Бочаров", Date.today.loc, "Будем играть голыми", '12:00', "19"]
      assert_not_contain "Латвия"
      check_email('riga@example.com', 
        ["Вася Пупкин", "заявка получена и будет рассмотрена", "pupkin@vasi.net", "Дмитрий Бочаров", "Рига", Date.today.loc, "новая", "Будем играть голыми", '12:00', "19"],
        ["принимаются", "Латвия"])

      click_link "Изменить"

      date = Date.today + 1.day
      fill_in "event_moderator_name", :with => 'Василий Пупкин'
      fill_in "event_more_info", :with => 'Будем играть в темноте'
      select_date("event_date", date.day, date.month, date.year)
      fill_in "event_game_time", :with => '12:30'
      click_button "Сохранить"

      assert_contain_multiple ["Параметры заявки изменены", "Василий Пупкин", "pupkin@vasi.net", "Рига", "Дмитрий Бочаров", (Date.today + 1.day).loc, 'Будем играть в темноте', '12:30', "19"]
      assert_not_contain "Латвия"
      check_email('riga@example.com', ["Василий Пупкин", "pupkin@vasi.net", "Дмитрий Бочаров", "Рига", (Date.today + 1.day).loc, "изменены", 'Будем играть в темноте', '12:30', "19"], ["Латвия"])
    }
  end

  def test_znatok_can_only_see_not_register
    bb2 = games(:bb2)
    do_with_users([:znatok]) {
      visit_and_get_deny_by_permission "/games/#{bb2.id}/events/new"
      visit_and_get_deny_by_permission "/games/#{bb2.id}/events/"
      visit "/games/#{bb2.id}/"
      assert_not_contain "Зарегистрироваться"
    }
  end

  def test_only_some_cities_can_register
    kg2 = games(:kg2)
    do_with_users([:hudjakov]) {
      visit "/games/#{kg2.id}"
      click_link "Зарегистрироваться"
      assert_contain_multiple ["Кельн", "Франкфурт"]
      assert_not_contain_multiple ["Рига", "Таллинн"]
    }
  end

  def test_resp_cannot_register_as_expired
    bb1 = games(:bb1)
    do_with_users([:trodor]) {
      visit "/games/#{bb1.id}"
      assert_not_contain "Зарегистрироваться"
      visit_and_get_deny_by_time "/games/#{bb1.id}/events/new"
    }
  end

  def test_org_can_see_registrations
    bb1 = games(:bb1)
    do_with_users([:marina]) {
      visit "/games/#{bb1.id}/events"
      assert_contain_multiple ["Вася", "vasja@example.org", "Дмитрий Бочаров", "Рига"]
      assert_contain_multiple ["Иван Иванов", "ivan@example.org", "Борис Шойхет", "Франкфурт"]
    }
  end
  
  def test_org_can_see_and_change_status
    kg2 = games(:kg2)
    kg2_frankfurt = events(:kg2_frankfurt)
    kg2_riga = events(:kg2_riga)
    do_with_users([:rodionov]) {
      visit "/games/#{kg2.id}/events"
      assert_contain_multiple ["новая", "отклонена"]
      select "принята", :from => "change_event_status_#{kg2_frankfurt.id}"      
      #Cannot test Ajax with Webrat/Rails
      #check_email('frankfurt@example.com', ["Иван Иванов", "принята"])
      select "принята", :from => "change_event_status_#{kg2_riga.id}"
      #check_email('riga@example.com', ["Вася", "принята"])
      #visit "/games/#{kg1.id}/events/#{kg1_frankfurt.id}"
      #assert_contain "принята"
      #visit "/games/#{kg1.id}/events/#{kg1_riga.id}"
      #assert_contain "принята"
    }
  end
  
  def test_not_org_cannot_change_status
    kg1 = games(:kg1)
    kg1_frankfurt = events(:kg1_frankfurt)
    do_with_users([:shojhet]) {
      visit "/games/#{kg1.id}/events/#{kg1_frankfurt.id}"
      assert_not_contain "Изменить статус"
    }
  end

end
