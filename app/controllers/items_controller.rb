class ItemsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def index
    if params[:user_id]
      user = User.find(params[:user_id])
      items = user.items
    else
      items = Item.all 
    end
    render json: items, include: :user
  end

  def show
    if params[:user_id]
      user = User.find(params[:user_id])
      item = user.items.find(params[:id])
    else
      item  = Item.find(params[:id])
    end
    render json: item, include: :user
  end

  def create
    if params[:user_id]
      user = User.find(params[:user_id])
      item = Item.create(item_params)
      user.items << item
    else
      item = Item.create(item_params)
    end
    render json: item, include: :user, status: :created
  end

  private

  def record_not_found
    render json: { error: "User not found" }, status: :not_found
  end

  def item_params
    params.permit(:name, :description, :price, :user_id)
  end

end
