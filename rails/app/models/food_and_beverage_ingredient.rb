# vim: ts=2

class FoodAndBeverageIngredient < ActiveRecord::Base
	attr_accessible :sequence
	has_many :food_and_beverage_ingredient_names
	belongs_to :country_code_type
	validates :food_and_beverage_ingredient_names, :length => { :minimum => 1 }
end
