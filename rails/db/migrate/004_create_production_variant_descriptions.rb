# vim: ts=2

class CreateProductionVariantDescriptions < ActiveRecord::Migration
	def change
		create_table :production_variant_descriptions do |t|
			t.string :string, limit: 70, null: false
			t.string :codelist_version, limit: 35, null: true
			t.string :language, limit: 80, null: false
			t.belongs_to :product_data_record
		end
	end
end
