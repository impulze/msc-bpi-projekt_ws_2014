# vim: ts=2

class CreateProductQuantityInformations < ActiveRecord::Migration
	def change
		create_table :product_quantity_informations do |t|
			t.belongs_to :product_data_record
			t.belongs_to :measurement_type
			t.float :percentage_of_alcohol_by_volume
		end
	end
end
