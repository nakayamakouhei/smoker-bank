require "test_helper"

class CustomCigaretteLogsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get custom_cigarette_logs_create_url
    assert_response :success
  end
end
