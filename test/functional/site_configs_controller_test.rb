require 'test_helper'

class SiteConfigsControllerTest < ActionController::TestCase
  setup do
    @site_config = site_configs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:site_configs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create site_config" do
    assert_difference('SiteConfig.count') do
      post :create, site_config: { content: @site_config.content, cover: @site_config.cover, key: @site_config.key, title: @site_config.title }
    end

    assert_redirected_to site_config_path(assigns(:site_config))
  end

  test "should show site_config" do
    get :show, id: @site_config
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @site_config
    assert_response :success
  end

  test "should update site_config" do
    put :update, id: @site_config, site_config: { content: @site_config.content, cover: @site_config.cover, key: @site_config.key, title: @site_config.title }
    assert_redirected_to site_config_path(assigns(:site_config))
  end

  test "should destroy site_config" do
    assert_difference('SiteConfig.count', -1) do
      delete :destroy, id: @site_config
    end

    assert_redirected_to site_configs_path
  end
end
