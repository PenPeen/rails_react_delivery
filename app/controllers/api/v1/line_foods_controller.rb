module Api
  module V1
    class LineFoodsController < ApplicationController
      before_action :set_food, only: %i[create replace]
      before_action :validate_ordered, only: %i[create]

      def index
        line_foods = LineFood.preload(:food, :restaurant).order(created_at: :desc)

        if line_foods.present?
          restaurant = line_foods.first.restaurant

          render json: {
            line_foods: line_foods.map { _1.slice(:id, :name, :count, :price) },
            restaurant:,
            total_price: line_foods.sum { _1.price }
          }, status: :ok
        else
          head :no_content
        end
      end

      def create
        set_line_food(@ordered_food)

        if @line_food.save
          render json: {
            line_food: @line_food,
            count: food_sum
          }, status: :created
        else
          head :unprocessable_entity
        end
      end

      def replace
        ActiveRecord::Base.transaction do
          LineFood.other_restaurant(@ordered_food.restaurant.id).each(&:destroy!)

          set_line_food(@ordered_food)

          if @line_food.save!
            render json: {
              line_food: @line_food,
              count: food_sum
            }, status: :created
          end
        rescue
          head :internal_server_error
        end
      end

      def cart_count
        render json: {
          count: food_sum
        }, status: :ok
      end

      private
        def set_food
          @ordered_food = Food.find(params[:food_id])
        end

        def food_sum
          LineFood.sum(:count)
        end

        def validate_ordered
          if LineFood.other_restaurant(@ordered_food.restaurant.id).exists?
            render json: {
              existing_restaurant: LineFood.other_restaurant(@ordered_food.restaurant.id).first.restaurant.name,
              new_restaurant: Food.find(params[:food_id]).restaurant.name
            }, status: :not_acceptable
          end
        end

        def set_line_food(ordered_food)
          if ordered_food.line_food.present?
            @line_food = ordered_food.line_food
            @line_food.attributes = {
              count: ordered_food.line_food.count + params[:count]
            }
          else
            @line_food = ordered_food.build_line_food(
              count: params[:count],
              restaurant: ordered_food.restaurant,
            )
          end
        end
    end
  end
end
