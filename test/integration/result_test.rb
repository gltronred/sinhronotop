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
      search_multiple_text_in_result_table ["Оки-доки", "Рига", 10]
      search_in_result_table(pv.name, false)

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
    ka = teams(:ka)
    do_with_users([:trodor]) {
      visit "/events/#{event.id}/results"
      add_team_listed(false, sp, event)
      add_team_listed(true, sp, event, "Марк Ленивкер", 1)
      click_link "Изменить"
      add_team_listed(true, ka, event, "Леонид К")
      click_link "Изменить"
      fill_in "listed_cap_name", :with => "Леонид Кандыба"
      click_button "Сохранить"
      search_multiple_text_in_result_table ["Крейзер Аврора", "Леонид Кандыба", 1, 2]
      search_in_result_table("Марк Ленивкер", false)
      search_in_result_table("7 пядей", false)

      check "team#{ka.id}_tour1_question8"
      check "team#{ka.id}_tour3_question29"
      uncheck "team#{ka.id}_tour2_question13"
      remove_team ka
    }
  end

  def test_add_team_if_no_cap_required
    event = events(:kg2_riga)
    sp = teams(:sp)
    do_with_users([:trodor]) {
      visit "/events/#{event.id}/results"
      add_team_new(true, "Rolling Stones", event.city)
      click_link "Изменить"
      fill_in "team_name", :with => "Scorpions"
      click_button "Сохранить"
      add_team_listed(true, sp, event, nil, 1)
      search_multiple_text_in_result_table ["Рига", "Scorpions", 1, 2]
      add_team_new(true, "Beatles", event.city, cities(:tallinn))
    }
  end

  def test_resp_imports_table
    event = events(:bb2_riga)
    sp = teams(:sp)
    ka = teams(:ka)
    do_with_users([:trodor]) {
      visit "/events/#{event.id}/results"
      add_team_listed(true, sp, event, "Марк Ленивкер", 1)
      add_team_listed(true, ka, event, "Максим Ли", 2)
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
      click_link "Изменить"
      fill_in "team_name", :with => "АБВГДейка"
      fill_in "listed_cap_name", :with => "Левушкин"
      select "Кельн", :from => "city_id"
      click_button "Сохранить"
      search_multiple_text_in_result_table ["АБВГДейка", "Левушкин", "Кельн", 1]
      add_team_new(true, "Утренняя почта", event.city, cities(:cologne), "Юрий Николаев")
      assert page.has_xpath?("//input[@type='checkbox']", :count => 72)
      sleep 3
      click_remove_and_confirm
      sleep 3
      search_in_result_table("АБВГДейка", false)
    }
  end

  def test_org_navigates_game_results
    game = games(:bb2)
    do_with_users([:marina]) {
      visit "/games/#{game.id}/results"
      search_multiple_text_in_result_table ["Против ветра", 14, "Оки-доки", 10, "7 пядей", 12]
      click_link "Тур 1"
      search_multiple_text_in_result_table ["Против ветра", 8, "Оки-доки", 4, "7 пядей", 5]
      click_link "Тур 2"
      search_multiple_text_in_result_table ["Против ветра", 2, "Оки-доки", 3, "7 пядей", 5]
      click_link "Тур 3"
      search_multiple_text_in_result_table ["Против ветра", 4, "Оки-доки", 3, "7 пядей", 2]
      click_link "Общие результаты"
      search_multiple_text_in_result_table ["Против ветра", 14, "Оки-доки", 10, "7 пядей", 12]
      assert !page.has_xpath?("//input")
    }
  end

  def test_resp_cannot_submit_as_expired
    game = games(:bb1)
    do_with_users([:trodor]) {
      visit "/games/#{game.id}/results"
      assert !page.has_xpath?("//input")
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
      search_multiple_text_in_result_table ["Против ветра", 10, "Оки-доки", 8]
      click_link "Тур 1"
      click_link "Тур 2"
      click_link "Тур 3"
      click_link "Общие результаты"
    }
  end

  private

  def search_multiple_text_in_result_table(array_to_search)
    array_to_search.each do |to_search|
      within(:xpath, "//table[@id='result_table']") do
        assert page.has_xpath?("//td[text()='#{to_search.to_s}']"), " #{to_search} not found in #{page_text(page)}"
      end
    end
  end

  def search_in_result_table(to_search, should_be_listed=true)
    to_search = to_search.to_s unless to_search.is_a?(String)
    within(:xpath, "//table[@id='result_table']") do
      expression = "//td[text()='#{to_search}']"
      el1 = page.has_xpath? "//td[text()='#{to_search}']"
      el2 = page.has_xpath? "//a[text()='#{to_search}']"
      if should_be_listed
        assert el1 || el2, " #{to_search} not found"
      else
        assert !el1 && !el2, " #{to_search} found"
      end
    end
  end

  def add_team_listed(should_be_added, team, event, cap_name=nil, local_index = nil)
    click_link "add_listed_team_link" if has_selector?("a#add_listed_team_link")
    select local_index.to_s, :from => "listed_local_index" if local_index
    select "#{team.name} (#{team.city.name})", :from => "result_team_id"
    fill_in "listed_cap_name", :with => cap_name if cap_name
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

  def add_team_new(should_be_added, name, event_city, team_city=nil, cap_name=nil, local_index = nil)
    click_link "add_new_team_link" if has_selector?("a#add_new_team_link")
    select local_index.to_s, :from => "new_local_index" if local_index
    fill_in "team_name", :with => name
    select team_city.to_s, :from => "team_city_id" if team_city
    fill_in "new_cap_name", :with => cap_name if cap_name
    confirm_alert
    click_button "team_submit"
    search_in_result_table(event_city.to_s, should_be_added) if should_be_added
    search_in_result_table(team_city.to_s, should_be_added) if team_city
    search_in_result_table(name, should_be_added)
    search_in_result_table(cap_name, should_be_added) if cap_name
  end

  def check_score(score)
    search_in_result_table(score)
    assert page.has_xpath?("//input[@type='checkbox'][@checked='checked']", :count => score)
  end

end
