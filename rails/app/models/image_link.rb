# vim: ts=2

class ImageLink < ActiveRecord::Base
	attr_accessible :url, :width, :height, :filesize
	belongs_to :basic_product_information
	belongs_to :image_type_code_type
	belongs_to :language_type_code_type
	belongs_to :measurement_type
	validates :image_type_code_type, :length => { :minimum => 1 }
end
