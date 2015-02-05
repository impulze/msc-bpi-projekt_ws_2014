# vim: ts=2

class ProductInformationLink < ActiveRecord::Base
	attr_accessible :url
	belongs_to :basic_product_information
	belongs_to :product_information_type_code_type
	belongs_to :language_type_code_type
	validates :product_information_type_code_type, :length => { :minimum => 1 }
end
