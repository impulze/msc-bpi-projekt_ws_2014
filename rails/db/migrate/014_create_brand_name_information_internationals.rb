# vim: ts=2

class CreateBrandNameInformationInternationals < ActiveRecord::Migration
	def change
		create_table :brand_name_information_internationals do |t|
			t.string :string, limit: 70, null: false
			t.string :codelist_version, limit: 35, null: true
			t.string :language, limit: 80, null: false
			t.belongs_to :brand_name_information
		end
	end
end
