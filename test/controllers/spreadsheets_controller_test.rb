require 'test_helper'

class SpreadsheetsControllerTest < ActionDispatch::IntegrationTest
  test "should create spreadsheet with proper instructions" do
    assert_difference('Spreadsheet.count') do
      post spreadsheets_url, params: {
        spreadsheet: {instructions: "1 1\n3"}
      }
    end
  end
  test "should respond with evaluated spreadsheet" do
    post spreadsheets_url, params: {
      spreadsheet: {instructions: "1 1\n3"}
    }
    assert_equal("1 1\n3.00000", @response.body)
  end
end
