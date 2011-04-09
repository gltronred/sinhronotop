require 'test_helper'
require 'integration/integration_test_helper'

class GameTest < ActionController::IntegrationTest
  include IntegrationTestHelper

  def test_dont_know_inputs
    kupr = tournaments(:kupr)
    do_with_users([:knop]) {
      visit "/tournaments/#{kupr.id}"
      click_link "Новый этап"
      uncheck "game_begin_dont_know"
      uncheck "game_game_begin_dont_know"
      uncheck "game_submit_disp_until_dont_know"
      
      fill_in "game_name", :with => "главный этап"
      fill_in "game_num_tours", :with =>"3"
      fill_in "game_num_questions", :with => "14"
      
      select_date("game_begin", 1, 10, 2014)
      select_date("game_game_begin", 12, 10, 2014)
      select_date("game_submit_disp_until", 15, 10, 2014)
      
      check "game_end_dont_know"
      check "game_game_end_dont_know"
      check "game_submit_appeal_until_dont_know"
      check "game_submit_results_until_dont_know"
      click_button "Сохранить"
      
      assert_contain_multiple ["1.10.2014", "12.10.2014", "15.10.2014"]
      
      within(:xpath, "//table[@id='table_games']") do
        click_link "Изменить"
      end
      uncheck "game_end_dont_know"
      uncheck "game_game_end_dont_know"
      uncheck "game_submit_appeal_until_dont_know"
      uncheck "game_submit_results_until_dont_know"
      check "game_begin_dont_know"
      check "game_game_begin_dont_know"
      check "game_submit_disp_until_dont_know"
      select_date("game_end", 10, 10, 2015)
      select_date("game_game_end", 13, 10, 2015)
      select_date("game_submit_appeal_until", 20, 10, 2015)
      select_date("game_submit_results_until", 25, 10, 2015)
      click_button "Сохранить"

      assert_not_contain_multiple ["1.10.2014", "12.10.2014", "15.10.2014"]
      assert_contain_multiple ["10.10.2015", "13.10.2015", "20.10.2015", "25.10.2015"]

      within(:xpath, "//table[@id='table_games']") do
        click_remove_and_confirm
      end
    }
  end

  def test_org_creates_and_edits_a_game
    kupr = tournaments(:kupr)
    do_with_users([:knop, :perlin]) {
      visit "/tournaments/#{kupr.id}"
      click_link "Новый этап"

      uncheck "game_begin_dont_know"
      uncheck "game_game_begin_dont_know"
      uncheck "game_submit_disp_until_dont_know"
      uncheck "game_end_dont_know"
      uncheck "game_game_end_dont_know"
      uncheck "game_submit_appeal_until_dont_know"
      uncheck "game_submit_results_until_dont_know"

      fill_in "game_name", :with => "1 этап"
      fill_in "game_num_tours", :with =>"3"
      fill_in "game_num_questions", :with => "14"
      select_date("game_begin", 1, 10, 2013)
      select_date("game_end", 10, 10, 2013)
      select_date("game_game_begin", 12, 10, 2013)
      select_date("game_game_end", 13, 10, 2013)
      select_date("game_submit_disp_until", 15, 10, 2013)
      select_date("game_submit_appeal_until", 20, 10, 2013)
      select_date("game_submit_results_until", 25, 10, 2013)
      click_button "Сохранить"

      assert_contain_multiple ["Этап создан", "1 этап", "3", "14", "1.10.2013", "10.10.2013", "12.10.2013", "13.10.2013", "15.10.2013", "20.10.2013", "25.10.2013", "нет"]

      within(:xpath, "//table[@id='table_games']") do
        click_link "Изменить"
      end

      fill_in "game_name", :with => "единственный этап"
      select_date("game_end", 11, 10, 2013)
      select_date("game_submit_disp_until", 16, 10, 2013)
      select_date("game_submit_appeal_until", 21, 10, 2013)
      check "game_publish_disp"
      check "game_publish_appeal"
      check "game_publish_results"
      click_button "Сохранить"

      assert_contain_multiple ["единственный этап", "3", "14", "1.10.2013", "11.10.2013", "12.10.2013", "13.10.2013", "16.10.2013", "21.10.2013", "25.10.2013", "да"]
      assert_not_contain 'нет'

      visit "/tournaments/#{kupr.id}"
      within(:xpath, "//table[@id='table_games']") do
        click_remove_and_confirm
      end
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

      visit "/tournaments/#{bb.id}"
      assert_contain_multiple ["Этап 1", "Этап 2"]
      assert_not_contain_multiple ["Новый этап", "Изменить", "Удалить"]
    }
  end


end
