require 'test_helper'
require 'integration/integration_test_helper'

class GameTest < ActionController::IntegrationTest
  include IntegrationTestHelper

  def test_org_creates_and_edits_a_game
    kupr = tournaments(:kupr)
    do_with_users([:knop, :perlin]) {
      visit "/tournaments/#{kupr.id}"
      click_link "Новый этап"

      fill_in "game_name", :with => "1 этап"
      fill_in "game_num_tours", :with =>"3"
      fill_in "game_num_questions", :with => "14"
      select_date("game_begin", 1, 10, 2013)
      select_date("game_end", 10, 10, 2013)
      select_date("game_submit_disp_until", 15, 10, 2013)
      select_date("game_submit_appeal_until", 20, 10, 2013)
      select_date("game_submit_results_until", 25, 10, 2013)
      click_button "Сохранить"

      assert_contain_multiple ["Этап создан", "1 этап", "3", "14", "1.10.2013", "10.10.2013", "15.10.2013", "20.10.2013", "25.10.2013", "false"]
      assert_not_contain 'true'

      click_link "Изменить"

      fill_in "game_name", :with => "единственный этап"
      select_date("game_end", 11, 10, 2013)
      select_date("game_submit_disp_until", 16, 10, 2013)
      select_date("game_submit_appeal_until", 21, 10, 2013)
      check "game_publish_disp"
      check "game_publish_appeal"
      check "game_publish_results"
      click_button "Сохранить"

      assert_contain_multiple ["единственный этап", "3", "14", "1.10.2013", "11.10.2013", "16.10.2013", "21.10.2013", "25.10.2013", "true"]
      assert_not_contain 'false'

      visit "/tournaments/#{kupr.id}"
      click_link "Этапы"
      click_remove_and_confirm
      assert_contain "Этап удален"
      assert_not_contain "единственный этап"
    }
  end

  def test_other_than_original_org_cannot_edit
    bb = tournaments(:bb)
    game = games(:bb1)
    do_with_users([:trodor, :knop, :znatok]) {
      visit_and_get_deny_by_permission "/tournaments/#{bb.id}/games/#{game.id}/edit"
      visit_and_get_deny_by_permission "/tournaments/#{bb.id}/games/new"

      visit "/tournaments/#{bb.id}/games/"
      assert_contain_multiple ["Этап 1", "Этап 2"]
      assert_not_contain_multiple ["Новый этап", "Изменить", "Удалить"]
    }
  end


end
