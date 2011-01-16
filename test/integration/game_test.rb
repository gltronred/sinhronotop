require 'test_helper'
require 'integration/integration_test_helper'

class GameTest < ActionController::IntegrationTest
  include IntegrationTestHelper
  
  def test_org_creates_and_edits_a_game
    login users(:org_kupr)
    kupr = tournaments(:kupr)
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
        
    assert_multiple_contain ["Этап создан", "1 этап", "3", "14", "1.10.2013", "10.10.2013", "15.10.2013", "20.10.2013", "25.10.2013"]
  end
  
  def test_other_than_original_org_cannot_edti
    
    
  end
  
  
end