require "test_helper"

class Company::WorkersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get company_workers_index_url
    assert_response :success
  end

  test "should get show" do
    get company_workers_show_url
    assert_response :success
  end

  test "should get edit" do
    get company_workers_edit_url
    assert_response :success
  end

  test "should get update" do
    get company_workers_update_url
    assert_response :success
  end

  test "should get destroy" do
    get company_workers_destroy_url
    assert_response :success
  end
end
