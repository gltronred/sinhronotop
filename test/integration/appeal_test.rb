require 'test_helper'
require 'integration/integration_test_helper'

class AppealTest < ActionController::IntegrationTest
  include IntegrationTestHelper

  def xtest_submit_long_appeal
    event = events(:bb2_riga)
    do_with_users([:trodor]) {
      visit "/events/#{event.id}/appeals"
      submit_appeal(32, 'зачет', "адамово яблоко", File.open("test/fixtures/appeal.txt",'r').read, ["Давая такой ответ", "http://www.autoforum.nnov.ru/forum/showthread.php?t=112753", "Яблоко само по себе, а его вкус сам по себе. Оригинально."])
    }
  end

  def test_resp_submits
    event = events(:bb2_riga)
    do_with_users([:trodor]) {
      
      visit "/events/#{event.id}/appeals"
      assert_contain_multiple ["обезьяна", "это мое любимое животное", "курица - не птица, как утверждается в вопросе"] #see my already submitted stuff 
      assert_not_contain_multiple ["Купидон", "другое имя бога Эрота"] #cannot see submitments from other events
      submit_appeal(2, 'зачет', "зеленый змий", "потому что зеленый")
      click_link "Изменить"
      submit_appeal(2, 'зачет', "красный богатырь", "потому что красный")
      assert_not_contain_multiple ["зеленый змий", "потому что зеленый"]
      click_remove_and_confirm
      assert_not_contain_multiple ["красный богатырь", "потому что красный"]
      submit_appeal(34, 'снятие', "", "потому что не самолет")
    }
  end

  def test_org_can_see
    game = games(:bb2)
    do_with_users([:marina]) {
      visit "/games/#{game.id}/appeals"
      assert_contain_multiple ["Франкфурт-на-Майне", "Рига", "зачет", "Купидон", "другое имя бога Эрота", "обезьяна", "зачет", "это мое любимое животное", "снятие", "курица - не птица, как утверждается в вопросе"]
    }
  end

  def test_org_cannot_submit_as_expired
    game = games(:bb1)
    do_with_users([:trodor]) {
      visit "/games/#{game.id}/appeals"
      assert_have_no_selector_multiple ['form input#appeal_question_index', 'form input#appeal_goal', 'form input#appeal_answer', 'form input#appeal_argument', 'form input#appeal_submit']      
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
      assert_contain_multiple ["зачет", "Купидон", "другое имя бога Эрота", "обезьяна", "зачет", "это мое любимое животное", "снятие", "курица - не птица, как утверждается в вопросе"]
    }
  end

  private

  def submit_appeal(question_index, goal, answer, argument, should_contain_strings=nil)
    select question_index.to_s, :from => "appeal_question_index"
    select goal, :from => "appeal_goal"
    fill_in "appeal_answer", :with => answer
    fill_in "appeal_argument", :with => argument
    click_button "Сохранить"
    should_contain_strings ||= [question_index.to_s, goal, answer, argument]
    assert_contain_multiple should_contain_strings
  end

end
