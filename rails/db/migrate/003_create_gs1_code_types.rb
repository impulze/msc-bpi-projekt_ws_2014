# vim: ts=2

class CreateGs1CodeTypes < ActiveRecord::Migration
	def change
		create_table :gs1_code_types do |t|
			t.string :string, limit: 80, null: false
			t.string :codelist_version, limit: 35, null: true
		end
	end
end
