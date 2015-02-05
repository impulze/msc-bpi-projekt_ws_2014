# vim: ts=2

class CreateFoodAndBeverageIngredientInformations < ActiveRecord::Migration
	def change
		create_table :food_and_beverage_ingredient_informations do |t|
			t.belongs_to :product_data_record
		end
	end
end
