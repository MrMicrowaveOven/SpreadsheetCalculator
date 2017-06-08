class SpreadsheetsController < ApplicationController
  skip_before_action :verify_authenticity_token
  def new
  end

  def create
    @spreadsheet = Spreadsheet.new(spreadsheet_params)
    is_input_validated = @spreadsheet.validate_input
    if is_input_validated != "validated"
      render status: 400, json: is_input_validated
      return
    end
    evaluated_spreadsheet = @spreadsheet.evaluate_spreadsheet
    @spreadsheet = Spreadsheet.new({instructions: evaluated_spreadsheet})

    if evaluated_spreadsheet.include?("cyclic dep")
      render status: 400, json: {Error: evaluated_spreadsheet}
    elsif @spreadsheet.save
      render status: 200, json: {instructions: evaluated_spreadsheet}
    else
      puts @spreadsheet.inspect
      render status: 400, json: {Post: "failure"}
    end
  end

  def index
    render status: 200, json: Spreadsheet.all
  end

  def destroy
    Spreadsheet.all.each do |request|
      request.destroy
    end
    render status: 400, json: {allSpreadsheets: "deleted"}
  end

  private
  def spreadsheet_params
    params.require(:spreadsheet).permit(:instructions)
  end
end
