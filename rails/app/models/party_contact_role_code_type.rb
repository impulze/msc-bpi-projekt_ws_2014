# vim: ts=2

class PartyContactRoleCodeType < Gs1CodeType
	validates :string, uniqueness: true
end
