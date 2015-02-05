# vim: ts=2

class CreateBrandNameInformationLocals < ActiveRecord::Migration
	def change
		create_table :brand_name_information_locals do |t|
			t.string :string, limit:70, null: false
			t.belongs_to :brand_name_information
		end
	end
end
