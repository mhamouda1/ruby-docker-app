require "test_helper"

class ExampleTest < ActionDispatch::IntegrationTest
  def test_home_page
    get "/"
    assert_equal 200, status
  end
end
