require 'test_helper'
require 'integration/integration_test_helper'

class AppealTest < ActionController::IntegrationTest
  include IntegrationTestHelper

  def test_resp_submits
    user = users(:trodor)
    event = events(:bb2_riga)
    login user
    visit "/events/#{event.id}/appeals"
    submit_appeal(14, 'зачет', "зеленый змий", "потому что зеленый")
    submit_appeal(34, 'снятие', "", "потому что не самолет")
    logout
  end

  def test_org_can_see
    user = users(:marina)
    game = games(:bb2)
    login user
    visit "/games/#{game.id}/appeals"
    assert_contain_multiple ["11", "обезьяна", "зачет", "это мое любимое животное", "25", "снятие", "курица - не птица, как утверждается в вопросе"]
    logout
  end

  def test_not_org_cannot_submit_or_see_as_not_published
    game = games(:bb2)
    [users(:znatok), users(:knop), users(:trodor)].each do |user|
      login user
      visit_and_get_deny_by_permission "/games/#{game.id}/appeals"
      logout
    end
  end

  def test_everyone_can_see_as_published
    game = games(:bb1)
    [users(:znatok), users(:knop), users(:trodor), users(:marina)].each do |user|
      login user
      visit "/games/#{game.id}/appeals"
      assert_contain_multiple ["11", "обезьяна", "зачет", "это мое любимое животное", "25", "снятие", "курица - не птица, как утверждается в вопросе"]
      logout
    end
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
