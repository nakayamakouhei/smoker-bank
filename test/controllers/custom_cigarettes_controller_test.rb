require "test_helper"

class CustomCigarettesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get custom_cigarettes_index_url
    assert_response :success
  end

  test "should get new" do
    get custom_cigarettes_new_url
    assert_response :success
  end

  test "should get create" do
    get custom_cigarettes_create_url
    assert_response :success
  end
end
