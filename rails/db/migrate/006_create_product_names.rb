# vim: ts=2

class CreateProductNames < ActiveRecord::Migration
	def change
		create_table :product_names do |t|
			t.string :string, limit: 80, null: false
			t.string :codelist_version, limit: 35, null: true
			t.string :language, limit: 80, null: false
			t.belongs_to :basic_product_information
		end
	end
end
