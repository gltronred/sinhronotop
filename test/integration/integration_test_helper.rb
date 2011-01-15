module IntegrationTestHelper
  def login_as_admin(url='/')
    basic_auth('ckgkresults@gmail.com', '34erdfcv')
    visit url
    assert_response :ok
  end
  
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

end
