require 'test_helper'
require 'integration/integration_test_helper'

class LongtextTest < ActionController::IntegrationTest
  include IntegrationTestHelper
  
  def test_create_edit_see_delete_for_game
    game = games(:kg1)
    do_with_users([:rodionov]) {
      visit "/games/#{game.id}"
      click_link "Добавить текст"
      fill_in "longtext_title", :with => "Вопросы 1 тура"
      text = File.open("test/fixtures/longtext.txt",'r').read
      fill_in "longtext_value", :with => text
      click_button "Сохранить"
      click_link "Вопросы 1 тура"
      assert_contain_multiple ["Дебют Дебюсси", "Заговаривал зубы"]
      visit "/games/#{game.id}"
      #click_link "Назад"
      click_link "Изменить текст"
      fill_in "longtext_title", :with => "Вопросы 1 тура и разминка"
      click_button "Сохранить"
      click_link "Вопросы 1 тура и разминка"
      visit "/games/#{game.id}"
      #click_link "Назад"
      confirm_alert
      click_on "Удалить текст"
      assert_contain "Этап 1"
      assert_not_contain "Вопросы 1 тура и разминка"
    }
  end

  def test_create_edit_see_delete_for_tournament
    t = tournaments(:kg)
    do_with_users([:rodionov]) {
      visit "/tournaments/#{t.id}"
      click_link "Добавить текст"
      uncheck "longtext_new_page"
      fill_in "longtext_title", :with => "Информация"
      fill_in "longtext_value", :with => "Турнир проводится федерацией интеллектуальных игр Германии"
      click_button "Сохранить"
      assert_contain_multiple ["Турнир проводится федерацией интеллектуальных игр Германии", "Информация"]
      click_link "Изменить текст"
      check "longtext_new_page"
      click_button "Сохранить"
      click_link "Информация"
      assert_contain_multiple ["Турнир проводится федерацией интеллектуальных игр Германии", "Информация"]
      #click_link "Назад"
      visit "/tournaments/#{t.id}"
      confirm_alert
      click_link "Удалить текст"
      assert_contain "Кубок Германии"
      assert_not_contain "Информация"
    }
  end

  
  def test_just_user_cannot_manage_but_see
    game = games(:bb1)
    t = tournaments(:bb)
    do_with_users([:trodor, :znatok]) {
      visit "/games/#{game.id}"
      assert_not_contain_multiple ["Добавить текст", "Изменить текст", "Удалить текст"]
      click_link "Синхрон"
      assert_not_contain_multiple ["Добавить текст", "Изменить текст", "Удалить текст"]
      visit "/tournaments/#{t.id}"
      assert_contain_multiple ["Информация о турнире", "проводимый с 2006 года Рижским клубом знатоков"]
      assert_not_contain_multiple ["Добавить текст", "Изменить текст", "Удалить текст"]
    }
  end
  
end