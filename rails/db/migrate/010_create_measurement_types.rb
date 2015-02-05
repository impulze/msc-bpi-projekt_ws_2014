# vim: ts=2

class CreateMeasurementTypes < ActiveRecord::Migration
	def change
		create_table :measurement_types do |t|
			t.string :unit_code, limit: 80, null: false
			t.string :codelist_version, limit: 35, null: true
			t.integer :value
		end
	end
end
