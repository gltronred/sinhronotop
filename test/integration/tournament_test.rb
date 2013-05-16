# -*- coding: utf-8 -*-
require_relative '../test_helper'
require_relative 'integration_test_helper'

class TournamentTest < ActionController::IntegrationTest
  include IntegrationTestHelper

  def test_other_than_admin_and_org_should_see_but_not_edit
    t = tournaments(:bb)
    do_with_users([:znatok, :trodor]) {
      visit_and_get_deny_by_permission "/tournaments/#{t.id}/edit"
      visit_and_get_deny_by_permission "/tournaments/new"

      visit "/tournaments"
      assert_not_contain_multiple ["Изменить", "Новый турнир", "Удалить"]

      visit "/tournaments/#{t.id}"
      assert_contain_multiple ["Этап 1", "Этап 2"]
    }
  end

  def test_org_edits
    t = tournaments(:bb)
    do_with_users([:marina]) {
      visit "/tournaments/#{t.id}"
      click_link "Изменить"
      click_button "Сохранить"
    }
  end

  def test_admin_creates_and_edits_tournament
    do_with_users([:perlin]) {
      create
      click_link "Изменить"
      uncheck "every_city"
      fill_in 'tournament_name', :with => 'Кубок Городов'
      check 'tournament_needTeams' #don't remove this - workaound as capybara doesn't fullfill the first "check"
      check 'tournament_needTeams'
      check 'tournament_appeal_for_dismiss'
      check 'tournament_cap_name_required'
      check 'tournament_time_required'
      select "турнир одноэтапный, считать не надо", :from => "tournament_calc_system_id"
      check cities(:cologne).id.to_s
      click_button 'Сохранить'

      assert_contain_multiple ["Настройки турнира изменены", "Кубок Городов", "турнир одноэтапный, считать не надо", "Кельн"]
      assert_not_contain_multiple ["Таллинн", "Франкфурт", "Рига", "все", "нет"]

      click_link "Изменить"
      assert page.has_xpath?("//input[@checked='checked'][@id='tournament_needTeams']")
      assert page.has_xpath?("//input[@checked='checked'][@id='tournament_appeal_for_dismiss']")

      visit "/tournaments"
      click_link 'Кубок Городов'
      click_remove_and_confirm
      assert_contain "Турнир удален"
      assert_not_contain 'Кубок Городов'
    }
  end

  def create
    visit "/tournaments"
    click_link 'Новый турнир'
    fill_in 'tournament_name', :with => 'ОКР'
    select "Константин Кноп (kupr@example.com)", :from => "tournament_user_id"
    check "every_city"
    select "не знаю пока", :from => "tournament_calc_system_id"
    click_button 'Сохранить'
    assert_contain_multiple ["Турнир создан", "все", "не знаю пока", "Кноп", "ОКР", "нет"]
  end

end
