# vim: ts=2

class ConsumerMarketingDescription < ActiveRecord::Base
	attr_accessible :string, :codelist, :language
	belongs_to :basic_product_information
end
