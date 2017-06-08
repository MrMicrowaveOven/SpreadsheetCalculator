class SpreadsheetsController < ApplicationController
  skip_before_action :verify_authenticity_token
  def new
  end

  def create
    @spreadsheet = Spreadsheet.new(spreadsheet_params)
    table_count_check = @spreadsheet.check_table_count
    evaluated_spreadsheet = @spreadsheet.evaluate_spreadsheet
    @spreadsheet = Spreadsheet.new({instructions: evaluated_spreadsheet})
    if !table_count_check
      render json: {Error: "Incorrect table dimensions"}
    elsif evaluated_spreadsheet.include?("cyclic dep")
      render json: {Error: evaluated_spreadsheet}
    elsif @spreadsheet.save
      render json: evaluated_spreadsheet
    else
      puts @spreadsheet.inspect
      render json: {Post: "failure"}
    end
  end

  def index
    render json: Spreadsheet.all
  end

  def destroy
    Spreadsheet.all.each do |request|
      request.destroy
    end
    render json: {allSpreadsheets: "deleted"}
  end

  private
  def spreadsheet_params
    params.require(:spreadsheet).permit(:instructions)
  end
end
