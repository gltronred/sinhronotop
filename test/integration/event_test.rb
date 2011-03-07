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
      choose "moderator_other"
      fill_in "event_moderator_name", :with => 'Вася Пупкин'
      fill_in "event_moderator_email", :with => 'pupkin@vasi.net'
      fill_in "event_more_info", :with => 'Будем играть голыми'
      select '12:00', :from => "event_game_time"
      fill_in "event_num_teams", :with => '19'
      select 'Рига', :from => "event_city_id"
      click_button "Сохранить"
      assert_contain_multiple ["Спасибо, заявка получена и будет рассмотрена", "Вася Пупкин", "Рига", "pupkin@vasi.net", "Дмитрий Бочаров", Date.today.loc, "Будем играть голыми", '12:00', "19"]
      assert_not_contain "Латвия"

      click_link "Изменить"
      date = Date.today + 1.day
      fill_in "event_moderator_name", :with => 'Василий Пупкин'
      fill_in "event_more_info", :with => 'Будем играть в темноте'
      select_date("event_date", date.day, date.month, date.year)
      select '12:30', :from => "event_game_time"
      click_button "Сохранить"
      assert_contain_multiple ["Параметры заявки изменены", "Василий Пупкин", "pupkin@vasi.net", "Рига", "Дмитрий Бочаров", (Date.today + 1.day).loc, 'Будем играть в темноте', '12:30', "19"]
      assert_not_contain "Латвия"

      click_link "Изменить"
      choose "moderator_self"
      click_button "Сохранить"
      assert_not_contain_multiple ["Василий Пупкин", "pupkin@vasi.net"]

      click_link "Изменить"
      choose "moderator_from_list"
      select "Константин Кноп", :from => "moderator_list"
      click_button "Сохранить"
      assert_not_contain_multiple ["Василий Пупкин", "pupkin@vasi.net"]
      assert_contain_multiple ["Константин Кноп", "kupr@example.com"]

      click_link "Изменить"
      choose "moderator_no"
      click_button "Сохранить"
      assert_contain_multiple ["Параметры заявки изменены", "Рига", "Дмитрий Бочаров", (Date.today + 1.day).loc, 'Будем играть в темноте', '12:30', "19"]
      
      click_link "этап Этап 2"
      click_link "игра в городе Рига #{(Date.today + 1.day).loc}"
      assert_contain_multiple ["Рига", "Дмитрий Бочаров", 'Будем играть в темноте']
    }

    do_with_users([:marina]) {
      visit "/games/#{bb2.id}"
      click_link "Все заявки"
      assert_contain_multiple ["127.0.0.1...", "все заявки (5)", "Рига", "Дмитрий Бочаров", (Date.today + 1.day).loc, 'Будем']
    }
  end

  def org_can_change_resp
    event = events(:kg2_frankfurt)
    do_with_users([:rodionov]) {
      visit "/games/#{event.id}/edit"
      select "Константин Кноп (kupr@example.com)", :from => "event_user_id"
      click_button "Сохранить"
      assert_contain_multiple ["Константин Кноп", "kupr@example.com"]
      assert_not_contain "Борис Шойхет"

      visit "/games/#{event.id}/edit"
      select "Борис Шойхет (frankfurt@example.com)", :from => "event_user_id"
      click_button "Сохранить"
      assert_not_contain_multiple ["Константин Кноп", "kupr@example.com"]
      assert_contain_multiple ["Борис Шойхет", "frankfurt@example.com"]
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

  def test_only_selected_cities_can_register
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
      #check_email(['frankfurt@example.com'], ["Иван Иванов", "принята"])
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
