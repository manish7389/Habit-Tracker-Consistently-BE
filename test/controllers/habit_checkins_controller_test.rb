require "test_helper"

class HabitCheckinsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get habit_checkins_create_url
    assert_response :success
  end
end
