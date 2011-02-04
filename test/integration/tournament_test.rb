require 'test_helper'
require 'integration/integration_test_helper'

class TournamentTest < ActionController::IntegrationTest
  include IntegrationTestHelper

  def test_other_than_admin_and_org_should_see_but_not_edit
    t = Tournament.find_by_name("Балтийский Берег")
    do_with_users([:znatok, :trodor]) {
      visit_and_get_deny_by_permission "/tournaments/#{t.id}/edit"
      visit_and_get_deny_by_permission "/tournaments/new"

      visit "/tournaments"
      assert_not_contain_multiple ["Изменить", "Новый турнир", "Удалить"]

      visit "/tournaments/#{t.id}"
      click_link "Этапы"
      assert_contain_multiple ["Этап 1", "Этап 2"]
      click_link "турнир Балтийский Берег"
    }
  end

  def test_org_edits
    t = Tournament.find_by_name("Балтийский Берег")
    do_with_users([:marina]) {
      visit "/tournaments/#{t.id}"
      click_link "Изменить параметры"
      click_button "Сохранить"
    }
  end

  def test_admin_creates_and_edits_tournament
    do_with_users([:perlin]) {
      create
      t = Tournament.last

      visit "/tournaments/#{t.id}/edit"
      assert_select "input[checked='checked']", :count => 0

      fill_in 'tournament[name]', :with => 'ААА Кубок Городов'
      check 'tournament[needTeams]'
      check 'tournament[appeal_for_dismiss]'
      click_button 'Сохранить'
      assert_contain_multiple ["Данные турнира изменены", "ААА Кубок Городов"]

      visit "/tournaments/#{t.id}/edit"
      assert_select "input[checked='checked'][id='tournament_needTeams']", :count => 1
      assert_select "input[checked='checked'][id='tournament_appeal_for_dismiss']", :count => 1

      visit "/tournaments/#{t.id}/edit"
      check "tournament_city_ids_"
      click_button 'Сохранить'
      assert_contain "Данные турнира изменены"
      assert_contain "Кельн"

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
      click_button 'Сохранить'
      assert_response :ok
      assert_contain "Турнир создан"
    end
  end

end
