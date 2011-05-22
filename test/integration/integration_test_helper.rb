require 'rubygems'
require 'capybara'
require 'capybara/dsl'
require 'rake'

#require 'akephalos'
#Capybara.javascript_driver = :akephalos
#Capybara.default_driver = :akephalos

Capybara.default_driver = :selenium
Capybara.app_host = 'http://localhost:3000'
Capybara.register_driver :selenium do |app|
  Capybara::Driver::Selenium.new(app, :browser => :firefox)
end

module IntegrationTestHelper
  include Capybara

  def login(user)
    login_form(user.email, 'znatok')
  end

  def login_form(email, password, success=true)
    visit home_path
    fill_in "email", :with => email
    fill_in "password", :with => password
    click_button "Войти"
    if success
      assert_contain "Добро пожаловать"
    else
      assert_contain "не удалось"
    end
  end

  def page_text(page)
    page.body.gsub(/<[a-zA-Z\/][^>]*>/, ' ').gsub(/\n\n/, ' ')
  end

  def assert_contain(str)
    assert page.has_content?(str), "#{str} not found in #{page_text(page)}"
  end

  def assert_not_contain(str)
    assert !page.has_content?(str), "#{str} found in #{page_text(page)}"
  end

  def login_basic_auth(user)
    basic_auth(user.email, user.password)
    visit home_path
    assert_response :ok
  end

  def visit_and_get_deny_by_permission(url)
    visit url
    assert_contain "недостаточно прав"
  end

  def visit_and_get_deny_by_time(url)
    visit url
    assert_contain "Невозможно из-за несоблюдения временных рамок"
  end

  def select_date(field_prefix, day, month, year)
    select day.to_s, :from => "#{field_prefix}_3i"
    select month.to_s, :from => "#{field_prefix}_2i"
    select year.to_s, :from => "#{field_prefix}_1i"
  end

  def assert_not_contain_multiple(arr)
    arr.each do |el|
      assert_not_contain el
    end
  end

  def assert_have_no_selector_multiple(arr)
    arr.each do |el|
      assert !has_selector?(el), "found #{el}"
      #assert_have_no_selector el
    end
  end

  def assert_contain_multiple(arr)
    arr.each do |el|
      assert_contain el
    end
  end

  def logout
    click_link "Выход"
    assert_contain "До свидания"
    #post logout_path
  end

  def do_with_users(user_array)
    user_array.each do |user|
      login users(user)
      yield
      logout
    end
  end

  def confirm_alert
    page.execute_script('window.confirm = function() { return true; }')
  end

  def click_remove_and_confirm
    page.execute_script('window.confirm = function() { return true; }')
    click_link "Удалить"
  end

end
