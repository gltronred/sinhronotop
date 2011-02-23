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
      check_td oki.name
      check_td(pv.name, false)
      check_score 8

      #edit
      check "team#{oki.id}_tour3_question28"
      check "team#{oki.id}_tour3_question29"
      uncheck "team#{oki.id}_tour2_question17"
      uncheck "team#{oki.id}_tour2_question19"
    }
  end

  def test_resp_adds_team_listed
    event = events(:bb2_riga)
    sp = teams(:sp)
    do_with_users([:trodor]) {
      visit "/events/#{event.id}/results"
      add_team_listed(false, sp)
      add_team_listed(true, sp, "Марк Ленивкер")
      check "team#{sp.id}_tour1_question8"
      check "team#{sp.id}_tour3_question29"
      uncheck "team#{sp.id}_tour2_question13"
      remove_team sp
    }
  end

  def test_add_team_if_no_cap_required
    event = events(:kg2_riga)
    sp = teams(:sp)
    do_with_users([:trodor]) {
      visit "/events/#{event.id}/results"
      add_team_listed(true, sp)
      add_team_new(true, "Rolling Stones")
      add_team_new(true, "Beatles")      
    }
  end

  def test_resp_imports_table
    event = events(:bb2_riga)
    sp = teams(:sp)
    ka = teams(:ka)
    do_with_users([:trodor]) {
      visit "/events/#{event.id}/results"
      add_team_listed(true, sp, "Марк Ленивкер")
      add_team_listed(true, ka, "Максим Ли")
      click_link "Импорт тура из Excel"
      fill_in "excel_input", :with => "+\t\t+\t\t+\t\t+\t+\t+\t\t\t\r\n1\t\t\t\t\t\t\t\t\t\t\t1"
      click_link "Импортировать"
      remove_team sp
      remove_team ka
    }
  end

  def test_resp_adds_team_new
    event = events(:bb2_riga)
    do_with_users([:trodor]) {
      visit "/events/#{event.id}/results"
      add_team_new(false, "Абвгдейка")
      add_team_new(true, "Абвгдейка", "Татьяна Кирилловна")
      add_team_new(true, "Утренняя почта", "Юрий Николаев")      
      assert_select("input[type='checkbox']", :count => 108)
      click_remove_and_confirm
      check_td("Абвгдейка", false)
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

  def check_td(string_to_search, should_be_listed=true)
    within '#result_table' do |scope|
      element = scope.field_by_xpath("//td[text()='#{string_to_search}']")
      if should_be_listed
        assert element
      else
        assert_nil element
      end
    end
  end

  def submit_disputed(question_index, answer)
    select question_index, :from => "disputed_question_index"
    fill_in "disputed_answer", :with => answer
    click_button "Сохранить"
    assert_contain_multiple [question_index.to_s, answer]
  end

  def add_team_listed(should_be_added, team, cap_name=nil)
    select "#{team.name} (#{team.city.name})", :from => "result_team_id"
    fill_in "result_cap_name", :with => cap_name if cap_name
    click_button "result_submit"
    check_td(team.name, should_be_added)
    check_td(cap_name, should_be_added) if cap_name
  end

  def remove_team(team)
    click_remove_and_confirm
    check_td(team.name, false)
  end

  def add_team_new(should_be_added, name, cap_name=nil)
    fill_in "team_name", :with => name
    fill_in "cap_name", :with => cap_name if cap_name
    click_button "team_submit"
    choose_ok_on_next_confirmation rescue false
    check_td(name, should_be_added)
    check_td(cap_name, should_be_added) if cap_name
  end

  def check_score(score)
    within '#result_table' do |scope|
      assert_not_nil scope.field_by_xpath("//td[text()='#{score}']")
    end
    assert_select("input[type='checkbox'][checked='checked']", :count => score)
  end

end
