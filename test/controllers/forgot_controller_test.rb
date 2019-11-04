require 'test_helper'

class ForgotControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get forgot_new_url
    assert_response :success
  end

  test "should get edit" do
    get forgot_edit_url
    assert_response :success
  end

end
