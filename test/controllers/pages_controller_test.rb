require 'test_helper'

class HighVoltage::PagesControllerTest < ActionController::TestCase
  test "should get home" do
    get :show, id: 'home'
    assert_response :success
    
    # ensure the data came with the page.
    assert_select "ul" do
        assert_select "li", 4
    end
  end
end