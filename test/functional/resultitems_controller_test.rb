require 'test_helper'

class ResultitemsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:resultitems)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create resultitem" do
    assert_difference('Resultitem.count') do
      post :create, :resultitem => { }
    end

    assert_redirected_to resultitem_path(assigns(:resultitem))
  end

  test "should show resultitem" do
    get :show, :id => resultitems(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => resultitems(:one).to_param
    assert_response :success
  end

  test "should update resultitem" do
    put :update, :id => resultitems(:one).to_param, :resultitem => { }
    assert_redirected_to resultitem_path(assigns(:resultitem))
  end

  test "should destroy resultitem" do
    assert_difference('Resultitem.count', -1) do
      delete :destroy, :id => resultitems(:one).to_param
    end

    assert_redirected_to resultitems_path
  end
end
