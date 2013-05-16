# -*- coding: utf-8 -*-
require_relative '../test_helper'
require_relative 'integration_test_helper'

class UserTest < ActionController::IntegrationTest
  include IntegrationTestHelper

  def test_registration
    visit home_path
    click_link "Зарегистрироваться"
    
    fill_in_register_form( nil, "schumacher@formel1.com", "ferrari", "ferrari")
    assert_contain "не может быть пустым"
    assert_not_contain_multiple ["Чтобы завершить регистрацию", "Привет"]
    
    fill_in_register_form( "Михаэль Шумахер", "schumacher@formel1.com", "ferrari", "ferrari4")
    assert_contain "не совпадает"
    assert_not_contain_multiple ["Чтобы завершить регистрацию", "Привет"]
    
    fill_in_register_form( "Михаэль Шумахер", "schumacher", "ferrari", "ferrari")
    assert_contain "не похож на email"
    assert_not_contain_multiple ["Чтобы завершить регистрацию", "Привет"]

    fill_in_register_form( "Михаэль Шумахер", "schumacher@formel1.com", "f1", "f1")
    assert_contain "пароль недостаточной длины"
    assert_not_contain_multiple ["Чтобы завершить регистрацию", "Привет"]

    fill_in_register_form( "Михаэль Шумахер", "schumacher@formel1.com", "ferrari", "ferrari")
    assert_contain "Чтобы завершить регистрацию"
    assert_not_contain_multiple ["Добро пожаловать", "Привет"]
  end
  
  def test_accomplish_registration_and_change_password
    login_form("milja@example.com", "znatok", false)
    url = "#{home_path}activate/234553ert"
    visit url
    assert_contain_multiple ["регистрация закончена", "Привет, Эмилия Хильц"]
    logout
    assert_not_contain "Привет, Эмилия Хильц"
    login_form("milja@example.com", "znatok", true)
    
    click_link "Эмилия Хильц"
    click_link "Сменить пароль"
    fill_in "user_password", :with => "miljushka"
    fill_in "user_password_confirmation", :with => "miljushka"
    click_button "Сохранить"
    assert_contain "Новый пароль действителен"
    logout
    
    login_form("milja@example.com", "znatok", false)
    login_form("milja@example.com", "miljushka", true)
    logout
  end

  def test_reset_password_reqiure
    visit home_path
    click_link "Я забыл(а) пароль"
    fill_in "user_email", :with => 'cologne@example.com'
    click_button "Послать"
    assert_contain "Код для восстановления послан на адрес cologne@example.com"
  end
    
  def test_reset_password_do  
    url = "#{home_path}reset/2a1b2c8d5e0f6"
    visit url
    fill_in "user_password", :with => "palatka"
    fill_in "user_password_confirmation", :with => "palatka"
    click_button "Сохранить"
    assert_contain "Привет, Илья Моргунов"
    logout
    login_form('aachen@example.com', "palatka")
    logout
  end

  def test_forwarded_to_wish_page_after_login
    game = games(:bb1)
    url = "/tournaments/#{game.tournament.id}/games/#{game.id}"
    visit url
    fill_in "email", :with => "znatok@example.com"
    fill_in "password", :with => "znatok"
    click_button "Войти"
    assert current_url.include?(url), "url=#{url}, current_url=#{current_url}"
    logout
  end

  def test_submit_error
    [users(:znatok), users(:knop)].each do |user|
      login user
      znatok = 'znatok' == user.status
      visit home_path
      click_link "Сообщить об ошибке"
      fill_in "name", :with => "Конечно Вася" if znatok
      fill_in "email", :with => "vasja@pupkin.info" if znatok
      fill_in "text", :with => "Не нравится мне тут все у вас"
      click_button "Отправить"
      assert_contain "Сообщение послано администратору, спасибо"
      logout
    end
  end
  
  private
  
  def fill_in_register_form(user_name, user_email, user_password, user_password_confirmation)
    fill_in "user_name", :with => user_name if user_name
    fill_in "user_email", :with => user_email if user_email
    fill_in "user_password", :with => user_password if user_password
    fill_in "user_password_confirmation", :with => user_password_confirmation if user_password_confirmation
    click_button "Зарегистрироваться"
  end

end
