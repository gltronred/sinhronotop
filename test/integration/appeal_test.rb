require 'test_helper'
require 'integration/integration_test_helper'

class AppealTest < ActionController::IntegrationTest
  include IntegrationTestHelper

  def test_resp_submits
    event = events(:bb2_riga)
    do_with_users([:trodor]) {
      visit "/events/#{event.id}/appeals"
      submit_appeal(14, 'зачет', "зеленый змий", "потому что зеленый")
      submit_appeal(34, 'снятие', "", "потому что не самолет")
    }
  end

  def test_org_can_see
    game = games(:bb2)
    do_with_users([:marina]) {
      visit "/games/#{game.id}/appeals"
      assert_contain_multiple ["11", "обезьяна", "зачет", "это мое любимое животное", "25", "снятие", "курица - не птица, как утверждается в вопросе"]
    }
  end

  def test_not_org_cannot_submit_or_see_as_not_published
    game = games(:bb2)
    do_with_users([:znatok, :knop, :trodor]) {
      visit_and_get_deny_by_permission "/games/#{game.id}/appeals"
    }
  end

  def test_everyone_can_see_as_published
    game = games(:bb1)
    do_with_users([:znatok, :knop, :trodor, :marina]) {
      visit "/games/#{game.id}/appeals"
      assert_contain_multiple ["11", "обезьяна", "зачет", "это мое любимое животное", "25", "снятие", "курица - не птица, как утверждается в вопросе"]
    }
  end

  private

  def submit_appeal(question_index, goal, answer, argument)
    select question_index, :from => "appeal_question_index"
    select goal, :from => "appeal_goal"
    fill_in "appeal_answer", :with => answer
    fill_in "appeal_argument", :with => argument
    click_button "Сохранить"
    assert_contain_multiple [question_index.to_s, goal, answer, argument]
  end

end
