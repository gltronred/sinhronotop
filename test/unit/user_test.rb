# -*- coding: utf-8 -*-
require_relative '../test_helper'
require_relative 'unit/unit_test_helper'

class UserTest < ActiveSupport::TestCase
  include UnitTestHelper
  
  def test_create_user
    user = User.create(:email => 'vasja@pupkin.net', :name => "Вася Пупкин", :password => '1234567', :password_confirmation => '1234567')
    check_email(["vasja@pupkin.net"], ["Вася Пупкин", "1234567", "Чтобы завершить регистрацию"])
    assert get_url_from_last_email
  end
end
