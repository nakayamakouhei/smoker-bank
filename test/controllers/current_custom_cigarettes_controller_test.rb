require "test_helper"

class CurrentCustomCigarettesControllerTest < ActionDispatch::IntegrationTest
  test "should get update" do
    get current_custom_cigarettes_update_url
    assert_response :success
  end
end
