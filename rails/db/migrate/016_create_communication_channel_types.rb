# vim: ts=2

class CreateCommunicationChannelTypes < ActiveRecord::Migration
	def change
		create_table :communication_channel_types do |t|
			t.string :value, :limit => 200, :null => false
			t.string :name, :limit => 200, :null => true
			t.belongs_to :communication_channel_code_type
			t.belongs_to :packaging_signature_line
		end
	end
end
