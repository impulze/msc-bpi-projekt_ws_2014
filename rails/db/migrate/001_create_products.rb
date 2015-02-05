# vim: ts=2

class CreateProducts < ActiveRecord::Migration
	def change
		create_table :products do |t|
			t.integer :gtin, scale: 14, null: false, uniqueness: true # xsd:string \d{14}
			t.integer :provider_gln, scale: 13, null: false # xsd:string \d{13}
			t.string :provider_name, null: false
			t.string :ttl, null: false # xsd:duration
			t.belongs_to :target_market
		end
	end
end
