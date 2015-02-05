# vim: ts=2

class CreateProductDataRecords < ActiveRecord::Migration
	def change
		create_table :product_data_records do |t|
			t.string :variant_effective_datetime, null: false # xsd:dateTime
			t.belongs_to :product
		end
	end
end
