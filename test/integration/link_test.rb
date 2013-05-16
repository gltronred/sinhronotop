# -*- coding: utf-8 -*-
require_relative '../test_helper'
require_relative 'integration_test_helper'

class LinkTest < ActionController::IntegrationTest
  include IntegrationTestHelper
  
  def test_create_edit_delete_for_game
    game = games(:kg1)
    do_with_users([:rodionov]) {
      visit "/games/#{game.id}"
      click_link "Добавить ссылку"
      fill_in "link_text", :with => "Test host Link"
      fill_in "link_url", :with => "www.test_host.com"
      click_button "Сохранить"
      assert_contain "Ссылка сохранена."
      click_link "Изменить ссылку"
      fill_in "link_text", :with => "Test host2 Link"
      fill_in "link_url", :with => "www.test_host2.com"
      click_button "Сохранить"
      assert_contain "Ссылка изменена."

      confirm_alert
      click_link "Удалить ссылку"
      assert_contain "Ссылка удалена."
    }
  end

  def test_create_edit_delete_for_tournament
    t = tournaments(:kg)
    do_with_users([:rodionov]) {
      visit "/tournaments/#{t.id}"
      click_link "Добавить ссылку"
      fill_in "link_text", :with => "Test host Link"
      fill_in "link_url", :with => "www.test_host.com"
      click_button "Сохранить"
      assert_contain "Ссылка сохранена."
      click_link "Изменить ссылку"
      fill_in "link_text", :with => "Test host2 Link"
      fill_in "link_url", :with => "www.test_host2.com"
      click_button "Сохранить"
      assert_contain "Ссылка изменена."
      confirm_alert
      click_link "Удалить ссылку"
      assert_contain "Ссылка удалена."
    }
  end

  def test_just_user_cannot_manage_but_see
    game = games(:bb1)
    t = tournaments(:bb)
    do_with_users([:trodor, :znatok]) {
      visit "/games/#{game.id}"
      assert_not_contain_multiple ["Добавить ссылку", "Изменить ссылку", "Удалить ссылку"]
      click_link "Синхрон"
      assert_not_contain_multiple ["Добавить ссылку", "Изменить ссылку", "Удалить ссылку"]
      visit "/tournaments/#{t.id}"
      assert_contain_multiple ["Информация о турнире", "проводимый с 2006 года Рижским клубом знатоков"]
      assert_not_contain_multiple ["Добавить ссылку", "Изменить ссылку", "Удалить ссылку"]
    }
  end

end
