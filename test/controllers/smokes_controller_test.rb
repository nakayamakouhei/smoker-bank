require "test_helper"

class SmokesControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get smokes_create_url
    assert_response :success
  end
end
