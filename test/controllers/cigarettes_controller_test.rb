require "test_helper"

class CigarettesControllerTest < ActionDispatch::IntegrationTest
  test "should get select" do
    get cigarettes_select_url
    assert_response :success
  end
end
