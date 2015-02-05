# vim: ts=2

class CreateConsumerMarketingDescriptions < ActiveRecord::Migration
	def change
		create_table :consumer_marketing_descriptions do |t|
			t.string :string, limit: 2500, null: false
			t.string :codelist_version, limit: 35, null: true
			t.string :language, limit: 80, null: false
			t.belongs_to :basic_product_information
		end
	end
end
