require 'test_helper'
require 'integration/integration_test_helper'

class ResultTest < ActionController::IntegrationTest
  include IntegrationTestHelper

  def test_resp_edits
    event = events(:bb2_riga)
    pv = teams(:pv)
    oki = teams(:oki)
    do_with_users([:trodor]) {
      visit "/events/#{event.id}/results"

      #see my earlier submitmets, don't see submitments from other events
      check_team_listed oki.name
      check_team_listed(pv.name, false)
      check_score 8

      #edit
      check "team#{oki.id}_tour3_question28"
      check "team#{oki.id}_tour3_question29"
      uncheck "team#{oki.id}_tour2_question17"
      uncheck "team#{oki.id}_tour2_question19"
    }
  end

  def test_resp_adds_team_from_list
    event = events(:bb2_riga)
    sp = teams(:sp)
    do_with_users([:trodor]) {
      visit "/events/#{event.id}/results"
      add_team sp
      check "team#{sp.id}_tour1_question8"
      check "team#{sp.id}_tour3_question29"
      uncheck "team#{sp.id}_tour2_question13"
      remove_team sp
    }
  end
  
  def test_resp_imports_table
    event = events(:bb2_riga)
    sp = teams(:sp)
    ka = teams(:ka)
    do_with_users([:trodor]) {
      visit "/events/#{event.id}/results"
      add_team sp
      add_team ka
      click_link "Импорт тура из Excel"
      fill_in "excel_input", :with => "+\t\t+\t\t+\t\t+\t+\t+\t\t\t\r\n1\t\t\t\t\t\t\t\t\t\t\t1"
      click_link "Импортировать"
      remove_team sp
      remove_team ka
    }
  end

  def test_resp_adds_team_from_input
    event = events(:bb2_riga)
    do_with_users([:trodor]) {
      visit "/events/#{event.id}/results"
      fill_in "team_name", :with => "Абвгдейка"
      click_button "team_submit"
      choose_ok_on_next_confirmation rescue false
      check_team_listed "Абвгдейка"
      assert_select("input[type='checkbox']", :count => 72)
      click_remove_and_confirm
      check_team_listed("Абвгдейка", false)
    }
  end

  def test_org_can_see
    game = games(:bb2)
    do_with_users([:marina]) {
      visit "/games/#{game.id}/results"
      assert_contain_multiple ["Против ветра", "10", "Оки-доки", "8"]
      assert_select("input", :count => 0)
    }
  end

  def test_resp_cannot_submit_as_expired
    game = games(:bb1)
    do_with_users([:trodor]) {
      visit "/games/#{game.id}/results"
      assert_select("input", :count => 0)
    }
  end

  def test_not_org_cannot_submit_or_see_as_not_published
    game = games(:bb2)
    do_with_users([:znatok, :knop, :trodor]) {
      visit_and_get_deny_by_permission "/games/#{game.id}/results"
    }
  end

  def test_everyone_can_see_as_published
    game = games(:bb1)
    do_with_users([:znatok, :knop, :trodor, :marina]) {
      visit "/games/#{game.id}/results"
      assert_contain_multiple ["Против ветра", "10", "Оки-доки", "8"]
    }
  end

  private

  def check_team_listed(team_name, listed=true)
    within '#result_table' do |scope|
      element = scope.field_by_xpath("//td[text()='#{team_name}']")
      listed && element
    end
  end

  def submit_disputed(question_index, answer)
    select question_index, :from => "disputed_question_index"
    fill_in "disputed_answer", :with => answer
    click_button "Сохранить"
    assert_contain_multiple [question_index.to_s, answer]
  end
  
  def add_team(team)
    select team.name, :from => "result_team_id"
    click_button "result_submit"
    check_team_listed team.name
  end
  
  def remove_team(team)
    click_remove_and_confirm
    check_team_listed(team.name, false)
  end

  def check_score(score)
    within '#result_table' do |scope|
      assert_not_nil scope.field_by_xpath("//td[text()='#{score}']")
    end
    assert_select("input[type='checkbox'][checked='checked']", :count => score)
  end

end
