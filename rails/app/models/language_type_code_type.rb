# vim: ts=2

class LanguageTypeCodeType < Gs1CodeType
	validates :string, uniqueness: true
end
