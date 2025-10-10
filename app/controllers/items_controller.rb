# app/controllers/items_controller.rb
class ItemsController < ApplicationController
  before_action :authenticate_user!

  def index
    @total_amount = current_user.total_amount
  end
end
