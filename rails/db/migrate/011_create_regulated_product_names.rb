# vim: ts=2

class CreateRegulatedProductNames < ActiveRecord::Migration
	def change
		create_table :regulated_product_names do |t|
			t.string :string, limit: 500, null: false
			t.string :codelist_version, limit: 35, null: true
			t.string :language, limit: 80, null: false
			t.belongs_to :basic_product_information
		end
	end
end
