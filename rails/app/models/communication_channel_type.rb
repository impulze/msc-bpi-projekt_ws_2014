# vim: ts=2

class CommunicationChannelType < ActiveRecord::Base
	attr_accessible :value, :name
	belongs_to :communication_channel_code_type
	validates :communication_channel_code_type, :length => { :minimum => 1 }
	belongs_to :packaging_signature_line
end
