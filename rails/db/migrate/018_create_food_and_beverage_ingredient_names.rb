# vim: ts=2

class CreateFoodAndBeverageIngredientNames < ActiveRecord::Migration
	def change
		create_table :food_and_beverage_ingredient_names do |t|
			t.string :string, limit: 70, null: false
			t.string :codelist_version, limit: 35, null: true
			t.string :language, limit: 80, null: false
			t.belongs_to :food_and_beverage_ingredient
		end
	end
end
