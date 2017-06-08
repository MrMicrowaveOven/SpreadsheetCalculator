require 'test_helper'

class SpreadsheetTest < ActiveSupport::TestCase
  test "should not save an empty spreadsheet" do
    spreadsheet = Spreadsheet.new
    assert_not spreadsheet.save
  end
  test "should not allow initialization of a spreadsheet with an incorrect key" do
    exception = assert_raises(Exception) {
      spreadsheet = Spreadsheet.new({
        instluctions: "3 2\nB2\n4 3 *\nC2\nA1 B1 / 2 +\n13\nB1 A2 / 2 *"
      })
    }
    assert_equal("unknown attribute 'instluctions' for Spreadsheet.", exception.message)
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
  test "should not save a spreadsheet with an unknown character" do
    spreadsheet = Spreadsheet.new({instructions: "3 2\nB2\n4 3 %\nC2\nA1 B1 / 2 +\n13\nB1 A2 / 2 *"})
    assert_not spreadsheet.save
  end
  test "should not save a spreadsheet with too many linebreaks" do
    spreadsheet = Spreadsheet.new({instructions: "3 2\n\nB2\n4 3 *\nC2\nA1 B1 / 2 +\n13\nB1 A2 / 2 *"})
    assert_not spreadsheet.save
  end
  test "should not save a spreadsheet with too many spaces" do
    spreadsheet = Spreadsheet.new({instructions: "3 2\nB2  \n4 3 *\nC2\nA1 B1 / 2 +\n13\nB1 A2 / 2 *"})
    assert_not spreadsheet.save
  end
  
  class TableCountCheckTest < ActiveSupport::TestCase
    test "should reject a spreadsheet with an incorrect table size" do
      spreadsheet = Spreadsheet.new({instructions: "2 2\nB2\n5\n4 3 *\nC2\nA1 B1 / 2 +\n13\nB1 A2 / 2 *"})
      exception = assert_raises(Exception) {spreadsheet.check_table_count}
      assert_equal("incorrect spreadsheet size", exception.message)
    end
  end
end
