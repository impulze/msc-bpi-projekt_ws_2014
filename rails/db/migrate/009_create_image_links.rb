# vim: ts=2

class CreateImageLinks < ActiveRecord::Migration
	def change
		create_table :image_links do |t|
			t.string :url, limit: 2500, null: false
			t.integer :height, unsigned: true
			t.integer :width, unsigned: true
			t.belongs_to :measurement_type
			t.belongs_to :basic_product_information
			t.belongs_to :image_type_code_type
			t.belongs_to :language_type_code_type
		end
	end
end
