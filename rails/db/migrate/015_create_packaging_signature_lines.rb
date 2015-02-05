# vim: ts=2

class CreatePackagingSignatureLines < ActiveRecord::Migration
	def change
		create_table :packaging_signature_lines do |t|
			t.string :contact_name, limit: 200, null: false
			t.string :contact_address, limit: 500, null: false
			t.integer :gln, scale: 13, null: false # xsd:string \d{13}
			t.belongs_to :party_contact_role_code_type
			t.belongs_to :basic_product_information
		end
	end
end
