require "test_helper"

class OrganizationsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get organizations_index_url
    assert_response :success
  end

  test "should get new" do
    get organizations_new_url
    assert_response :success
  end

  test "should get create" do
    get organizations_create_url
    assert_response :success
  end

  test "should get enroll" do
    get organizations_enroll_url
    assert_response :success
  end
end
