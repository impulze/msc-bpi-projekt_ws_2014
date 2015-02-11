# vim: ts=2
#
class ApplicationController < ActionController::Base
	protect_from_forgery

	def get_gln
		2865195100007
	end

	def generate_gtin
		gln = get_gln
		max = Product.maximum(:gtin)

		# This is 12 digits (removed control digit from GLN)
		gln_prefix = gln.to_s[0..-2].to_i

		if max.nil?
			current_max = gln_prefix
		else
			# This is 12 digits (removed control digit from stored GTIN)
		        current_max = max.to_s[0..-2].to_i
		end

		# Add one to the current highest used GTIN, prepend 0 (need 13 digits for calculation)
		num = '0' + (current_max + 1).to_s

		# Calculate check digit
		check = -3 * (num[0].to_i + num[2].to_i + num[4].to_i + num[6].to_i + num[8].to_i + num[10].to_i + num[12].to_i)
		check -= (num[1].to_i + num[3].to_i + num[5].to_i + num[7].to_i + num[9].to_i + num[11].to_i)
		check %= 10

		num + check.to_s
	end
end
