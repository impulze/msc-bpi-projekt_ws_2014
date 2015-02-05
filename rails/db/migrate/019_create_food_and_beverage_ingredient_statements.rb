# vim: ts=2

class CreateFoodAndBeverageIngredientStatements < ActiveRecord::Migration
	def change
		create_table :food_and_beverage_ingredient_statements do |t|
			t.string :string, limit: 2500, null: false
			t.string :codelist_version, limit: 35, null: true
			t.string :language, limit: 80, null: false
			t.belongs_to :food_and_beverage_ingredient_information
		end
	end
end
