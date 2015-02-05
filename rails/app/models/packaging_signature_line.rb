# vim: ts=2

class PackagingSignatureLine < ActiveRecord::Base
	attr_accessible :contact_name, :contact_address, :gln
	has_many :communication_channel_types
	belongs_to :party_contact_role_code_type
	validates :party_contact_role_code_type, :length => { :minimum => 1 }
end
