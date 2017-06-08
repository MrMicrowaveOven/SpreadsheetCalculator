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

  class CheckTableCountTest < ActiveSupport::TestCase
    test "should return false when passed a spreadsheet with an incorrect table size" do
      spreadsheet = Spreadsheet.new({instructions: "2 2\nB2\n5\n4 3 *\nC2\nA1 B1 / 2 +\n13\nB1 A2 / 2 *"})
      assert_not spreadsheet.check_table_count
    end
    test "should return true when passed an empty 0 x 0 spreadsheet " do
      spreadsheet = Spreadsheet.new({instructions: "0 0"})
      assert spreadsheet.check_table_count
    end
    test "should return false when passed a single-cell 1 x 0 spreadsheet " do
      spreadsheet = Spreadsheet.new({instructions: "1 0\n3"})
      assert_not spreadsheet.check_table_count
    end
    test "should return true when passed a single-cell 1 x 1 spreadsheet " do
      spreadsheet = Spreadsheet.new({instructions: "1 1\n3"})
      assert spreadsheet.check_table_count
    end
    test "should return true when passed a spreadsheet with a correct table size" do
      spreadsheet = Spreadsheet.new({instructions: "3 2\nB2\n4 3 *\nC2\nA1 B1 / 2 +\n13\nB1 A2 / 2 *"})
      assert spreadsheet.check_table_count
    end
  end

  class EvaluateSpreadsheetTest < ActiveSupport::TestCase
    test "should give proper output of a valid spreadsheet (1)" do
      spreadsheet = Spreadsheet.new({
        instructions: "3 2\nB2\n4 3 *\nC2\nA1 B1 / 2 +\n13\nB1 A2 / 2 *"
      })
      assert_equal(
        spreadsheet.evaluate_spreadsheet,
        "3 2\n13.00000\n12.00000\n7.78378\n3.08333\n13.00000\n7.78378"
      )
    end
    test "should give proper output of a valid spreadsheet (2)" do
      spreadsheet = Spreadsheet.new({
        instructions: "3 2\nB1\n4 5 *\nA1\nA1 B2 / 2 +\n3\n39 A2 B2 * /"
      })
      assert_equal(
        spreadsheet.evaluate_spreadsheet,
        "3 2\n20.00000\n20.00000\n20.00000\n8.66667\n3.00000\n1.50000"
      )
    end
    test "should raise cyclic_error" do
      spreadsheet = Spreadsheet.new({
        instructions: "3 2\nB2\n4 3 *\nC2\nA1 C2 / 2 +\n13\nB1 A2 / 2 *"
      })
      # exception = assert_raises(Exception) {
      assert_equal(
        spreadsheet.evaluate_spreadsheet,
        "cyclic dep detectected. trace: C1 >> C2 >> A2 >> C2"
      )
      # }
      # assert_equal(
        # "cyclic dep detectected. trace: C1 >> C2 >> A2 >> C2"
        # exception.message
      # )
    end
  end
end
