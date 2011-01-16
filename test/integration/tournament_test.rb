require 'test_helper'
require 'integration/integration_test_helper'

class TournamentTest < ActionController::IntegrationTest
  include IntegrationTestHelper

  def test_other_than_admin_should_see_but_not_edit
    t = Tournament.find_by_name("Балтийский Берег")
    [users(:znatok), users(:org_bb), users(:resp)].each do |user|
      login(user)
      ["/tournaments/#{t.id}/edit"].each do |url|
        visit_and_get_deny url
      end
      visit "/tournaments/#{t.id}"
      click_link "Этапы"
      assert_contain "Этап 1"
      assert_contain "Этап 2"
      click_link "турнир Балтийский Берег"
    end
  end

  def test_admin_creates_and_edits_tournament
    assert_difference 'Tournament.count', 1 do
      login users(:admin)
      visit "/tournaments"
      click_link 'Новый турнир'
      fill_in 'tournament[name]', :with => 'ОКР'
      fill_in 'tournament[org_email]', :with => 'knop@example.org'
      click_button 'Сохранить'
      assert_response :ok
      assert_contain "Турнир создан"

      visit "/tournaments/#{Tournament.last.id}/edit"
      assert_select "input[checked='checked']", :count => 0

      fill_in 'tournament[name]', :with => 'Кубок Городов'
      check 'tournament[needTeams]'
      check 'tournament[appeal_for_dismiss]'
      click_button 'Сохранить'
      assert_contain "Данные турнира изменены"

      assert_contain "Кубок Городов"

      visit "/tournaments/#{Tournament.last.id}/edit"
      assert_select "input[checked='checked'][id='tournament_needTeams']", :count => 1
      assert_select "input[checked='checked'][id='tournament_appeal_for_dismiss']", :count => 1

      visit "/tournaments/#{Tournament.last.id}/edit"
      check "tournament_city_ids_"
      click_button 'Сохранить'
      assert_contain "Данные турнира изменены"
      assert_contain "Кельн"
    end
  end

  def test_admin_deletes_tournament
    assert_difference 'Tournament.count', -1 do
      login users(:admin)
      visit "/tournaments"
      click_button 'Удалить'
      choose_ok_on_next_confirmation rescue false
      assert_response :ok
      assert_contain "Турнир удален"
    end
  end

end
