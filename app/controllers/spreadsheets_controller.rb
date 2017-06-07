class SpreadsheetsController < ApplicationController
  skip_before_action :verify_authenticity_token
  def new
  end
  def create
    render json: {Post: "Success!"}
  end
end
