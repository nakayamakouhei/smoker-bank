require "test_helper"

class CurrentCigarettesControllerTest < ActionDispatch::IntegrationTest
  test "should get update" do
    get current_cigarettes_update_url
    assert_response :success
  end
end
