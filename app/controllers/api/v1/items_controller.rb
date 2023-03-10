# frozen_string_literal: true

class Api::V1::ItemsController < ApplicationController
  before_action :set_item, only: [:update, :show, :destroy]
  def index
    items = Item.preload(:inventory_level).all
    render json: ItemsRepresenter.new(items).as_json
  end

  def show
    render json: ItemRepresenter.new(@item).as_json
  end

  def create
    item = Item.new(item_params)
    if item.save
      render json: ItemRepresenter.new(item).as_json, status: :created
    else
      render json: item.errors.full_messages, status: :unprocessable_entity
    end
  end

  def update
    if @item.update(item_params)
      render json: ItemRepresenter.new(@item).as_json, status: :ok
    else
      render json: @item.errors.full_messages, status: :unprocessable_entity
    end
  end

  def destroy
    @item.destroy!
    head :no_content
  end

  private

  def item_params
    params.require(:item).permit(:name, :price, :size, :color)
  end

  def set_item
    @item = Item.find(params[:id])
  end
end
