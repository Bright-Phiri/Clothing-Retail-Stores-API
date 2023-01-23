# frozen_string_literal: true

class Api::V1::InventoryLevelsController < ApplicationController
  before_action :set_inventory_level, only: [:update, :show]
  def index
    inventory_levels = InventoryLevel.all
    render json: inventory_levels
  end

  def show
    render json: @inventory_level
  end

  def create
    item = Item.find(params[:item_id])
    raise StandardError, 'Inventory level already exists' unless item.inventory_level.nil?

    inventory_level = item.create_inventory_level(inventory_level_params)
    if inventory_level.new_record?
      render json: inventory_level.errors.full_messages, status: :unprocessable_entity
    else
      render json: inventory_level, status: :created
    end
  end

  def update
    if @inventory_level.update(inventory_level_params)
      render json: @inventory_level, status: :ok
    else
      render json: @inventory_level.errors.full_messages, status: :unprocessable_entity
    end
  end

  def destroy
    InventoryLevel.find(params[:id]).destroy!
    head :no_content
  end

  private

  def inventory_level_params
    params.require(:inventory_level).permit(:quantity, :reorder_level, :supplier)
  end

  def set_inventory_level
    item = Item.find(params[:item_id])
    @inventory_level = item.inventory_level
  end
end
