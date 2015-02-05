# vim: ts=2

class FoodAndBeverageIngredientInformation < ActiveRecord::Base
	has_many :food_and_beverage_ingredient_statements
	has_many :food_and_beverage_ingredients
	belongs_to :product_data_record
end
