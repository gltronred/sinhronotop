module IntegrationTestHelper
  def login(user)
    basic_auth(user.email, user.password)
    visit "/"
    assert_response :ok
  end

  def visit_and_get_deny(url)
    visit url
    #assert_redirected_to home_path
    assert_contain "недостаточно прав"
  end

  def select_date(field_prefix, day, month, year)
    select day.to_s, :from => "#{field_prefix}_3i"
    select month.to_s, :from => "#{field_prefix}_2i"
    select year.to_s, :from => "#{field_prefix}_1i"
  end

  def assert_multiple_contain(arr)
    arr.each do |el|
      assert_contain el
    end
  end


end
