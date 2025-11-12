require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get update_notification_time" do
    get users_update_notification_time_url
    assert_response :success
  end
end
