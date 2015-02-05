# vim: ts=2

class CommunicationChannelCodeType < Gs1CodeType
	validates :string, uniqueness: true
end
