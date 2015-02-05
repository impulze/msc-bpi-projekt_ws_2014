# vim: ts=2

class FoodAndBeverageIngredientStatement < ActiveRecord::Base
	attr_accessible :string, :codelist_version, :language
	belongs_to :food_and_beverage_ingredient_information
end
