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
      search_in_result_table oki.name
      search_in_result_table oki.city.name
      search_in_result_table "Рига"
      search_in_result_table(pv.name, false)
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
      add_team_listed(false, sp, event)
      add_team_listed(true, sp, event, "Марк Ленивкер")
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
      add_team_listed(true, sp, event)
      add_team_new(true, "Rolling Stones", event.city)
      click_link "Изменить данные команды"
      fill_in "team_name", :with => "Scorpions"
      click_button "Сохранить"
      assert_contain_multiple ["Рига", "Scorpions"]
      add_team_new(true, "Beatles", event.city, cities(:tallinn))
    }
  end

  def test_resp_imports_table
    event = events(:bb2_riga)
    sp = teams(:sp)
    ka = teams(:ka)
    do_with_users([:trodor]) {
      visit "/events/#{event.id}/results"
      add_team_listed(true, sp, event, "Марк Ленивкер")
      add_team_listed(true, ka, event, "Максим Ли")
      click_link "Импорт тура из Excel"
      fill_in "excel_input", :with => "+\t\t+\t\t+\t\t+\t+\t+\t\t\t\r\n1\t\t\t\t\t\t\t\t\t\t\t1"
      click_link "Импортировать"
      remove_team sp
      remove_team ka
    }
  end

  def test_resp_adds_team_new
    event = events(:bb2_tallinn)
    do_with_users([:trodor]) {
      visit "/events/#{event.id}/results"
      add_team_new(false, "Абвгдейка", event.city)
      add_team_new(true, "Абвгдейка", event.city, nil, "Татьяна Кирилловна")
      click_link "Изменить данные команды"
      fill_in "team_name", :with => "АБВГДейка"
      fill_in "result_cap_name", :with => "Левушкин"
      select "Кельн", :from => "city_id"
      click_button "Сохранить"
      assert_contain_multiple ["АБВГДейка", "Левушкин", "Кельн"]
      add_team_new(true, "Утренняя почта", event.city, cities(:cologne), "Юрий Николаев")
      assert_select("input[type='checkbox']", :count => 72)
      click_remove_and_confirm
      search_in_result_table("АБВГДейка", false)
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

  def search_in_result_table(string_to_search, should_be_listed=true)
    within '#result_table' do |scope|
      element = scope.field_by_xpath("//td[text()='#{string_to_search}']") || scope.field_by_xpath("//a[text()='#{string_to_search}']")
      if should_be_listed
        assert element, " #{string_to_search} not found in #{scope.dom}"
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

  def add_team_listed(should_be_added, team, event, cap_name=nil)
    select "#{team.name} (#{team.city.name})", :from => "result_team_id"
    fill_in "result_cap_name", :with => cap_name if cap_name
    click_button "result_submit"
    search_in_result_table(event.city.name, should_be_added) if should_be_added
    search_in_result_table(team.city.name, should_be_added) if should_be_added
    search_in_result_table(team.name, should_be_added)
    search_in_result_table(cap_name, should_be_added) if cap_name && should_be_added
  end

  def remove_team(team)
    click_remove_and_confirm
    search_in_result_table(team.name, false)
  end

  def add_team_new(should_be_added, name, event_city, team_city=nil, cap_name=nil)
    fill_in "team_name", :with => name
    select team_city.to_s, :from => "team_city_id" if team_city
    fill_in "cap_name", :with => cap_name if cap_name
    click_button "team_submit"
    choose_ok_on_next_confirmation rescue false
    search_in_result_table(event_city.to_s, should_be_added) if should_be_added
    search_in_result_table(team_city.to_s, should_be_added) if team_city
    search_in_result_table(name, should_be_added)
    search_in_result_table(cap_name, should_be_added) if cap_name
  end

  def check_score(score)
    search_in_result_table(score.to_s)
    assert_select("input[type='checkbox'][checked='checked']", :count => score)
  end

end
