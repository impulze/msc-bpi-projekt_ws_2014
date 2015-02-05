# vim: ts=2

class Product < ActiveRecord::Base
	attr_accessible :gtin, :provider_gln, :provider_name, :ttl
	belongs_to :target_market
	has_many :product_data_records
	validates :gtin, uniqueness: true
	validates :target_market, :length => { :minimum => 1 }
	validates :product_data_records, :length => { :minimum => 1 }
end
