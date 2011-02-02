require 'test_helper'
require 'integration/integration_test_helper'

class CityTest < ActionController::IntegrationTest
  include IntegrationTestHelper
  
  def test_no_org_or_admin_has_to_see_and_edit
    frankfurt = City.find_by_name 'Франкфурт-на-Майне'
    [users(:znatok), users(:trodor)].each do |user|
      login user

      visit_and_get_deny "/cities/#{frankfurt.id}/edit"
      visit_and_get_deny "/cities/#{frankfurt.id}"
      visit_and_get_deny "/cities/"
      
      visit home_path
      assert_not_contain "Города"
      
      logout
    end
  end
  
  def test_org_or_admin_can_see_and_edit
    [users(:perlin), users(:knop)].each do |user|
      login user
      
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
      click_link "Удалить"
      choose_ok_on_next_confirmation rescue false
      assert_not_contain /Абиджан/
            
      logout
    end
  end
  
end