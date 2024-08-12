module Api
  module V1
    class OrdersController < ApplicationController
      def create
        posted_line_foods = LineFood.where(id: params[:line_food_ids])
        order = Order.new(
          total_price: total_price(posted_line_foods),
        )

        order.save_with_update_line_foods!(posted_line_foods)
        head :no_content
      rescue
        head :internal_server_error
      end

      private
        def total_price(posted_line_foods)
          posted_line_foods.sum { |line_food| line_food.total_amount } + posted_line_foods.first.restaurant.fee
        end
    end
  end
end
