require 'test_helper'
require 'integration/integration_test_helper'

class DisputedTest < ActionController::IntegrationTest
  include IntegrationTestHelper

  def test_resp_submits
    event = events(:bb2_riga)
    do_with_users([:trodor]) {
      visit "/events/#{event.id}/disputeds"
      assert_contain_multiple ["крокодил", "бегемот"] #see my already submitted stuff 
      assert_not_contain "гиппопотам" #cannot see submitments from other events
      submit_disputed(2, "шестой элемент")
      click_link "Изменить"
      submit_disputed(2, "уголь")
      assert_not_contain "шестой элемент"
      click_remove_and_confirm
      assert_not_contain "уголь"
      submit_disputed(34, "кулинария")
    }
  end

  def test_org_can_see
    game = games(:bb2)
    do_with_users([:marina]) {
      visit "/games/#{game.id}/disputeds"
      assert_contain_multiple ["Франкфурт-на-Майне", "Рига", "крокодил", "бегемот", "гиппопотам"]
    }
  end

  def test_resp_cannot_submit_as_expired
    game = games(:bb1)
    do_with_users([:trodor]) {
      visit "/games/#{game.id}/disputeds"
      assert_have_no_selector_multiple ['form input#disputed_question_index', 'form input#disputed_answer', 'form input#disputed_submit']      
    }
  end
  
  def test_not_org_cannot_submit_or_see_as_not_published
    game = games(:bb2)
    do_with_users([:znatok, :knop, :trodor]) {
      visit_and_get_deny_by_permission "/games/#{game.id}/disputeds"
    }
  end

  def test_everyone_can_see_as_published
    game = games(:bb1)
    do_with_users([:znatok, :knop, :trodor, :marina]) {
      visit "/games/#{game.id}/disputeds"
      assert_contain_multiple ["12", "крокодил", "бегемот", "гиппопотам"]
    }
  end

  private

  def submit_disputed(question_index, answer)
    select question_index.to_s, :from => "disputed_question_index"
    fill_in "disputed_answer", :with => answer
    click_button "Сохранить"
    assert_contain_multiple [question_index.to_s, answer]
  end

end
