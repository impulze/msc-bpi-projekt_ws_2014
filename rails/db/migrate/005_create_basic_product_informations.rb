# vim: ts=2

class CreateBasicProductInformations < ActiveRecord::Migration
	def change
		create_table :basic_product_informations do |t|
			t.belongs_to :product_data_record
			t.integer :gpc_category_code, scale: 8, null: false # xsd:string \d{8}
		end
	end
end
