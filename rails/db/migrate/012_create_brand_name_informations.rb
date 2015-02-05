# vim: ts=2

class CreateBrandNameInformations < ActiveRecord::Migration
	def change
		create_table :brand_name_informations do |t|
			t.belongs_to :basic_product_information
		end
	end
end
