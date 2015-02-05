# vim: ts=2

class TargetMarket < Gs1CodeType
	has_many :products
	validates :string, uniqueness: true
end
