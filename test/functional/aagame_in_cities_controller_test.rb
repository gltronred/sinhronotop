require 'test_helper'

class GameInCitiesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:game_in_cities)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create game_in_city" do
    assert_difference('GameInCity.count') do
      post :create, :game_in_city => { }
    end

    assert_redirected_to game_in_city_path(assigns(:game_in_city))
  end

  test "should show game_in_city" do
    get :show, :id => game_in_cities(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => game_in_cities(:one).to_param
    assert_response :success
  end

  test "should update game_in_city" do
    put :update, :id => game_in_cities(:one).to_param, :game_in_city => { }
    assert_redirected_to game_in_city_path(assigns(:game_in_city))
  end

  test "should destroy game_in_city" do
    assert_difference('GameInCity.count', -1) do
      delete :destroy, :id => game_in_cities(:one).to_param
    end

    assert_redirected_to game_in_cities_path
  end
end
