# vim: ts=2

class CreateProductInformationLinks < ActiveRecord::Migration
	def change
		create_table :product_information_links do |t|
			t.string :url, limit: 2500, null: false
			t.belongs_to :basic_product_information
			t.belongs_to :product_information_type_code_type
			t.belongs_to :language_type_code_type
		end
	end
end
