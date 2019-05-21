require 'test_helper'

class NotificationsControllerTest < ActionDispatch::IntegrationTest
  test "should get link_through" do
    get notifications_link_through_url
    assert_response :success
  end

end
