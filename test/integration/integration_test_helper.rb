module IntegrationTestHelper
  def login(user)
    visit home_path
    fill_in "email", :with => user.email
    fill_in "password", :with => 'znatok'
    click_button "Войти"
    assert_response :ok
    assert_contain "Добро пожаловать"
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

  def assert_contain_multiple(arr)
    arr.each do |el|
      assert_contain el
    end
  end
  
  def logout
    post logout_path
  end
  
  def do_with_users(user_array)
    user_array.each do |user|
      login users(user)
      yield
      logout
    end
  end
    


end
