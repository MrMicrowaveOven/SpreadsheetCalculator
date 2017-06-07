class SpreadsheetsController < ApplicationController
  skip_before_action :verify_authenticity_token
  def new
  end

  def create
    # render json: params
    puts params.inspect
    @spreadsheet = Spreadsheet.new(spreadsheet_params)
    if @spreadsheet.save
      render json: @spreadsheet
    else
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
