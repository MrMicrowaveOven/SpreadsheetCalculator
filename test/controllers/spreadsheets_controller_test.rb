require 'test_helper'

class SpreadsheetsControllerTest < ActionDispatch::IntegrationTest
  test "should return error json if format is incorrect" do
    post spreadsheets_url, params: {
      spreadsheet: {instructions: "1 2\n3 \n4"}
    }
    assert_equal('{"Error":"Improper input format"}', @response.body)
    assert_equal(400, @response.status)
  end
  test "should return error if number of cells is incorrect" do
    post spreadsheets_url, params: {
      spreadsheet: {instructions: "1 1\n3\n4"}
    }
    assert_equal('{"Error":"Incorrect table dimensions"}', @response.body)
    assert_equal(400, @response.status)
  end
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
    assert_equal(200, @response.status)
  end
end
