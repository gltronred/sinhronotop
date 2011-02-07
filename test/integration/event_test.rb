require 'test_helper'
require 'integration/integration_test_helper'

class EventTest < ActionController::IntegrationTest
  include IntegrationTestHelper

  def test_resp_registers
    bb2 = games(:bb2)
    do_with_users([:trodor]) {
      visit "/games/#{bb2.id}"
      click_link "Зарегистрироваться"
      select_date("event_date", 16, 10, 2011)
      fill_in "event_moderator_name", :with => 'Вася Пупкин'
      fill_in "event_moderator_email", :with => 'pupkin@vasi.net'
      click_button "Сохранить"

      assert_contain_multiple ["Регистрация прошла успешно, ждите подтверждения по email", "Вася Пупкин", "pupkin@vasi.net", "Дмитрий Бочаров", "16.10.2011"]
      check_email('riga@example.com', ["Вася Пупкин", "pupkin@vasi.net", "Дмитрий Бочаров", "16.10.2011"])

      click_link "Изменить"

      fill_in "event_moderator_name", :with => 'Василий Пупкин'
      select_date("event_date", 17, 10, 2011)
      click_button "Сохранить"

      assert_contain_multiple ["Параметры изменены, ждите подтверждения по email", "Василий Пупкин", "pupkin@vasi.net", "Дмитрий Бочаров", "17.10.2011"]
      check_email('riga@example.com', ["Василий Пупкин", "pupkin@vasi.net", "Дмитрий Бочаров", "17.10.2011"])
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

end
