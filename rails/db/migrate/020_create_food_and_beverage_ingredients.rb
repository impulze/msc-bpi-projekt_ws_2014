# vim: ts=2

class CreateFoodAndBeverageIngredients < ActiveRecord::Migration
	def change
		create_table :food_and_beverage_ingredients do |t|
			t.belongs_to :food_and_beverage_ingredient_information
			t.belongs_to :country_code_type
			t.integer :sequence
		end
	end
end
