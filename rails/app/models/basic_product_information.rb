# vim: ts=2

class BasicProductInformation < ActiveRecord::Base
	attr_accessible :gpc_category_code
	has_many :product_names
	has_many :consumer_marketing_descriptions
	has_many :product_information_links
	has_many :image_links
	has_many :regulated_product_names
	has_one :brand_name_information
	has_many :packaging_signature_lines
	belongs_to :product_data_record
	validates :product_names, :length => { :minimum => 1 }
	validates :brand_name_information, :length => { :minimum => 1 }
end
