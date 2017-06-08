require 'test_helper'

class SpreadsheetTest < ActiveSupport::TestCase
  test "the truth" do
    assert true
  end
  test "should not save an empty spreadsheet" do
    spreadsheet = Spreadsheet.new
    assert_not spreadsheet.save
  end
  test "should not save a spreadsheet that doesn't begin with a size" do
    spreadsheet = Spreadsheet.new({instructions: "Hello"})
    assert_not spreadsheet.save
  end
  test "should save a spreadsheet with a blank size" do
    spreadsheet = Spreadsheet.new({instructions: "0 0"})
    assert spreadsheet.save
  end
  test "should save a standard spreadsheet" do
    spreadsheet = Spreadsheet.new({instructions: "3 2\nB2\n4 3 *\nC2\nA1 B1 / 2 +\n13\nB1 A2 / 2 *"})
    assert spreadsheet.save
  end
  test "should reject a spreadsheet with an unknown character" do
    spreadsheet = Spreadsheet.new({instructions: "3 2\nB2\n4 3 %\nC2\nA1 B1 / 2 +\n13\nB1 A2 / 2 *"})
    assert_not spreadsheet.save
  end
  test "should reject a spreadsheet with too many linebreaks" do
    spreadsheet = Spreadsheet.new({instructions: "3 2\n\nB2\n4 3 %\nC2\nA1 B1 / 2 +\n13\nB1 A2 / 2 *"})
    assert_not spreadsheet.save
  end
  test "should reject a spreadsheet with too many spaces" do
    spreadsheet = Spreadsheet.new({instructions: "3 2\nB2  \n4 3 %\nC2\nA1 B1 / 2 +\n13\nB1 A2 / 2 *"})
    assert_not spreadsheet.save
  end
end
