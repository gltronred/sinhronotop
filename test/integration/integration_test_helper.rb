module IntegrationTestHelper
  def login_as_admin(url='/')
    basic_auth('ckgkresults@gmail.com', '34erdfcv')
    visit url
    assert_response :ok
  end

end
