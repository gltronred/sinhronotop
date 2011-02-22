require 'test_helper'
require 'integration/integration_test_helper'

class TournamentTest < ActionController::IntegrationTest
  include IntegrationTestHelper

  def test_other_than_admin_and_org_should_see_but_not_edit
    t = tournaments(:bb)
    do_with_users([:znatok, :trodor]) {
      visit_and_get_deny_by_permission "/tournaments/#{t.id}/edit"
      visit_and_get_deny_by_permission "/tournaments/new"

      visit "/tournaments"
      assert_not_contain_multiple ["Изменить", "Новый турнир", "Удалить"]

      visit "/tournaments/#{t.id}"
      assert_contain_multiple ["Этап 1", "Этап 2"]
    }
  end

  def test_org_edits
    t = tournaments(:bb)
    do_with_users([:marina]) {
      visit "/tournaments/#{t.id}"
      click_link "Изменить"
      click_button "Сохранить"
    }
  end

  def test_admin_creates_and_edits_tournament
    do_with_users([:perlin]) {
      create
      t = Tournament.last

      visit "/tournaments/#{t.id}/edit"
      #assert_select "input[checked='checked']", :count => 0

      fill_in 'tournament[name]', :with => 'ААА Кубок Городов'
      uncheck "every_city"
      check "tournament_city_ids_"
      check 'tournament[needTeams]'
      check 'tournament[appeal_for_dismiss]'
      check 'tournament[cap_name_required]'
      select "турнир одноэтапный, считать не надо", :from => "tournament[calc_system_id]"
      click_button 'Сохранить'
      
      assert_contain_multiple ["Настройки турнира изменены", "ААА Кубок Городов", "турнир одноэтапный, считать не надо", "Кельн"]
      assert_not_contain_multiple ["Таллинн", "Франкфурт", "Рига", "все", "нет"]

      visit "/tournaments/#{t.id}/edit"
      assert_select "input[checked='checked'][id='tournament_needTeams']", :count => 1
      assert_select "input[checked='checked'][id='tournament_appeal_for_dismiss']", :count => 1

      assert_difference 'Tournament.count', -1 do
        visit "/tournaments"
        click_remove_and_confirm
        assert_response :ok
        assert_contain "Турнир удален"
      end
    }
  end

  def create
    assert_difference 'Tournament.count', 1 do
      visit "/tournaments"
      click_link 'Новый турнир'
      fill_in 'tournament[name]', :with => 'ОКР'
      select /Кноп/, :from => "tournament[user_id]"
      check "every_city"
      select "не знаю пока", :from => "tournament[calc_system_id]"
      click_button 'Сохранить'
      assert_response :ok
      assert_contain_multiple ["Турнир создан", "все", "не знаю пока", "Кноп", "ОКР", "нет"]
    end
  end

end
