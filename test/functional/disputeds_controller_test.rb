require 'test_helper'

class DisputedsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:disputeds)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create disputed" do
    assert_difference('Disputed.count') do
      post :create, :disputed => { }
    end

    assert_redirected_to disputed_path(assigns(:disputed))
  end

  test "should show disputed" do
    get :show, :id => disputeds(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => disputeds(:one).to_param
    assert_response :success
  end

  test "should update disputed" do
    put :update, :id => disputeds(:one).to_param, :disputed => { }
    assert_redirected_to disputed_path(assigns(:disputed))
  end

  test "should destroy disputed" do
    assert_difference('Disputed.count', -1) do
      delete :destroy, :id => disputeds(:one).to_param
    end

    assert_redirected_to disputeds_path
  end
end
