require 'test_helper'
require 'integration/integration_test_helper'

class CityTest < ActionController::IntegrationTest
  include IntegrationTestHelper

  def test_no_org_or_admin_has_to_see_and_edit
    frankfurt = City.find_by_name 'Франкфурт-на-Майне'
    do_with_users([:znatok, :trodor]) {
      visit_and_get_deny_by_permission "/cities/#{frankfurt.id}/edit"
      visit_and_get_deny_by_permission "/cities/#{frankfurt.id}"
      visit_and_get_deny_by_permission "/cities/"

      visit home_path
      assert_not_contain "Города"
    }
  end

  def test_org_or_admin_can_see_and_edit
    do_with_users([:perlin, :knop]) {
      visit home_path
      click_link "Города"
      assert_contain_multiple ["Франкфурт-на-Майне", "Таллинн", "Рига", "Кельн"]
      click_link "Добавить город"
      fill_in "city_name", :with => "Абиждан"
      click_button "Сохранить"
      assert_contain_multiple ["Абиждан", "Франкфурт-на-Майне", "Таллинн", "Рига", "Кельн"]
      click_link "Изменить"
      fill_in "city_name", :with => "Абиджан"
      click_button "Сохранить"
      assert_contain_multiple ["Абиджан", "Франкфурт-на-Майне", "Таллинн", "Рига", "Кельн"]
      #click_remove_and_confirm
      #assert_not_contain /Абиджан/
    }
  end

end
