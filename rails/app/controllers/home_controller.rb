# encoding: UTF-8
# vim: ts=2

class ExampleProduct
	def initialize(gtin)
		@gtin = gtin
	end

	def product_data_records
		pdr = Class.new

		def pdr.basic_product_informations
			bi = Class.new

			def bi.product_names
				return [
					{:language => 'DE', :string => 'Deutsches Produkt'},
					{:language => 'EN', :string => 'Englisches Produkt'}
				]
			end

			def bi.consumer_marketing_descriptions
				return [
					{:language => 'DE', :string => 'Deutsche Marketingbeschreibung'},
					{:language => 'EN', :string => 'Englische Marketingbeschreibung'}
				]
			end

			def bi.regulated_product_names
				return [
					{:language => 'DE', :string => 'Deutscher regulierter Produktname'},
					{:language => 'EN', :string => 'Englischer regulierter Produktname'},
				]
			end

			def bi.product_information_links
				link = Class.new

				def link.product_information_type_code_type
					return {:string => 'WEBSITE'}
				end

				def link.set_gtin(gtin)
					@gtin = gtin
				end

				def link.[](x)
					return {:url => 'http://eta-ori.net:8080/item.xml?gtin=' + @gtin.to_s}[x]
				end

				link.set_gtin(@gtin)

				return [link]
			end

			def bi.set_gtin(gtin)
				@gtin = gtin
			end

			def bi.image_links
				link = Class.new

				def link.image_type_code_type
					return {:string => 'PRODUCT_LABEL_IMAGE'}
				end

				def link.[](x)
					return {:url => 'http://upload.wikimedia.org/wikipedia/commons/0/07/AKE_Duff_Beer_IMG_5244_edit.jpg'}[x]
				end

				return [link]
			end

			bi.set_gtin(@gtin)

			return [bi]
		end

		def pdr.food_and_beverage_ingredient_informations
			fabii = Class.new

			def fabii.food_and_beverage_ingredient_statements
				return [
					{:string => 'Wie sind die Zutaten zusammengestellt?'}
				]
			end

			def fabii.food_and_beverage_ingredients
				ing1 = Class.new

				def ing1.food_and_beverage_ingredient_names
					return [
						{:string => 'Eine Zutat'},
					]
				end

				def ing1.[](x)
					return {:sequence => 1}[x]
				end

				ing2 = Class.new

				def ing2.food_and_beverage_ingredient_names
					return [
						{:string => 'Noch eine Zutat'},
					]
				end

				def ing2.[](x)
					return {:sequence => 2}[x]
				end

				return [ing1, ing2]
			end

			return [fabii]
		end

		def pdr.product_quantity_informations
			pqi = Class.new

			def pqi.[](x)
				return {:percentage_of_alcohol_by_volume => 5}[x]
			end

			[pqi]
		end

		def pdr.production_variant_description
			return {:string => 'Variante'}
		end

		def pdr.set_gtin(gtin)
			@gtin = gtin
		end

		pdr.set_gtin(@gtin)

		[pdr]
	end

	def [](x)
		return {:gtin => @gtin}[x]
	end

end

class HomeController < ApplicationController
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

	def send_request(request)
		require 'net/http'
		http = Net::HTTP.new("127.0.0.3", 18888)
		http.request(request)
	end

	def index
		respond_to do |format|
			format.html { render 'index' }
		end
	end

	def item
		@errors = []
		@status = []

		respond_to do |format|
			format.xml { render 'item' }
		end
	end

	def save_db(params)
		require 'rmagick'
		require 'open-uri'
		gtin = params[:gtin]
		gln = get_gln

		tm = TargetMarket.where(:string => 276).first_or_create
		now = DateTime.now
		pdr = ProductDataRecord.new(:variant_effective_datetime => now.iso8601())
		vdesc = ProductionVariantDescription.new(:string => params[:variante], :language => 'DE')
		pdr.production_variant_description = vdesc
		bi = BasicProductInformation.new(:gpc_category_code => '10000159')
		pn1 = ProductName.new(:string => params[:name_DE], :language => 'DE')
		pn1.basic_product_information = bi
		pn2 = ProductName.new(:string => params[:name_EN], :language => 'EN')
		pn2.basic_product_information = bi
		rpn1 = RegulatedProductName.new(:string => params[:regname_DE], :language => 'DE')
		rpn1.basic_product_information = bi
		rpn2 = RegulatedProductName.new(:string => params[:regname_EN], :language => 'EN')
		rpn2.basic_product_information = bi
		cmd1 = ConsumerMarketingDescription.new(:string => params[:cmd_DE], :language => 'DE')
		cmd1.basic_product_information = bi
		cmd2 = ConsumerMarketingDescription.new(:string => params[:cmd_EN], :language => 'EN')
		cmd2.basic_product_information = bi
		bni = BrandNameInformation.new
		bnil = BrandNameInformationLocal.new(:string => 'Duff')
		bni.brand_name_information_local = bnil
		bi.brand_name_information = bni
		ltc = LanguageTypeCodeType.where(:string => 'DE').first_or_create
		pil = ProductInformationLink.new(:url => params[:infourl_WEBSITE])
		pil.language_type_code_type = ltc
		pitc = ProductInformationTypeCodeType.where(:string => 'WEBSITE').first_or_create
		pil.product_information_type_code_type = pitc
		imgurl = params[:bildurl_PRODUCT_LABEL_IMAGE]
		images = Magick::ImageList.new
		begin
			imgstream = open(imgurl)
		rescue Exception => e
			raise Exception.new('An error occured while opening the product image URI %s (%s).' % [imgurl, e.message])
		end
		images.from_blob(imgstream.read)
		width = images[0].columns
		height = images[0].rows
		fsize = images[0].filesize / 1000000.0
		il = ImageLink.new(:url => imgurl, :height => height, :width => width)
		il.language_type_code_type = ltc
		itc = ImageTypeCodeType.where(:string => 'PRODUCT_LABEL_IMAGE').first_or_create
		il.image_type_code_type = itc
		fs = MeasurementType.where(:unit_code => '4L', :value => fsize).first_or_create
		il.measurement_type = fs
		psl = PackagingSignatureLine.new(:contact_name => 'Duff Brewery', :contact_address => 'Elbchaussee 111, 20095 Hamburg', :gln => gln)
		pcr = PartyContactRoleCodeType.where(:string => 'BRAND_OWNER').first_or_create
		psl.party_contact_role_code_type = pcr
		ccw = CommunicationChannelType.new(:value => 'http://example.com')
		ccwc = CommunicationChannelCodeType.where(:string => 'WEBSITE').first_or_create
		ccw.communication_channel_code_type = ccwc
		cct = CommunicationChannelType.new(:value => '+494011112222333', :name => 'Hotline')
		cctc = CommunicationChannelCodeType.where(:string => 'TELEPHONE').first_or_create
		cct.communication_channel_code_type = cctc
		cce = CommunicationChannelType.new(:value => 'duff@example.com')
		ccec = CommunicationChannelCodeType.where(:string => 'EMAIL').first_or_create
		cce.communication_channel_code_type = ccec
		psl.communication_channel_types.push(ccw)
		psl.communication_channel_types.push(cct)
		psl.communication_channel_types.push(cce)
		bi.packaging_signature_lines.push(psl)
		fbii = FoodAndBeverageIngredientInformation.new
		fbis = FoodAndBeverageIngredientStatement.new(:string => params[:inhaltsangabe], :language => 'DE')
		fbii.food_and_beverage_ingredient_statements.push(fbis)
		params[:inhaltsstoff].keys.each do |ih_key|
			fbin = FoodAndBeverageIngredientName.new(:string => params[:inhaltsstoff][ih_key], :language => 'DE')
			fbi = FoodAndBeverageIngredient.new(:sequence => ih_key)
			fbi.food_and_beverage_ingredient_names.push(fbin)
			fbi.country_code_type = CountryCodeType.where(:string => 'DE').first_or_create
			fbii.food_and_beverage_ingredients.push(fbi)
		end
		pqi = ProductQuantityInformation.new(:percentage_of_alcohol_by_volume => params[:alkoholgehalt])
		nc = MeasurementType.where(:unit_code => 'millilitre', :value => 500).first_or_create
		pqi.measurement_type = nc
		p = Product.new(:gtin => gtin, :provider_gln => gln, :provider_name => 'Duff Brewery', :ttl => 'P1D')
		p.target_market = tm
		bi.product_names.push(pn1)
		bi.product_names.push(pn2)
		bi.regulated_product_names.push(rpn1)
		bi.regulated_product_names.push(rpn2)
		bi.consumer_marketing_descriptions.push(cmd1)
		bi.consumer_marketing_descriptions.push(cmd2)
		bi.product_information_links.push(pil)
		bi.image_links.push(il)
		pdr.basic_product_informations.push(bi)
		pdr.food_and_beverage_ingredient_informations.push(fbii)
		pdr.product_quantity_informations.push(pqi)
		p.product_data_records.push(pdr)
		p.save!
	end

	def update_db(params)
		require 'rmagick'
		require 'open-uri'

		product = Product.where(:gtin => params[:gtin]).first
		pdr = product.product_data_records[0]
		bi = pdr.basic_product_informations[0]
		fabii = pdr.food_and_beverage_ingredient_informations[0]
		pqi = pdr.product_quantity_informations[0]

		pdr.production_variant_description[:string] = params[:variante]

		bi.product_names.each do |pn|
			if pn[:language] == 'DE'
				pn[:string] = params[:name_DE]
			else
				pn[:string] = params[:name_EN]
			end

			pn.save!
		end

		bi.regulated_product_names.each do |rpn|
			if rpn[:language] == 'DE'
				rpn[:string] = params[:regname_DE]
			else
				rpn[:string] = params[:regname_EN]
			end

			rpn.save!
		end

		bi.consumer_marketing_descriptions.each do |cmd|
			if cmd[:language] == 'DE'
				cmd[:string] = params[:cmd_DE]
			else
				cmd[:string] = params[:cmd_EN]
			end

			cmd.save!
		end

		bi.image_links.each do |il|
			if il.image_type_code_type[:string] == 'PRODUCT_LABEL_IMAGE'
				imgurl = params[:bildurl_PRODUCT_LABEL_IMAGE]
				images = Magick::ImageList.new
				imgstream = open(imgurl)
				images.from_blob(imgstream.read)
				width = images[0].columns
				height = images[0].rows
				fsize = images[0].filesize / 1000000.0
				il[:url] = imgurl
				il[:height] = height
				il[:width] = width

				fs = MeasurementType.where(:unit_code => '4L', :value => fsize).first_or_create
				il.measurement_type = fs

				fs.save!
				il.save!
			end
		end

		fs = fabii.food_and_beverage_ingredient_statements[0]
		fs[:string] = params[:inhaltsangabe]
		fs.save!

		fabii.food_and_beverage_ingredients.each do |fi|
			fi.delete
		end

		params[:inhaltsstoff].keys.each do |ih_key|
			fbin = FoodAndBeverageIngredientName.new(:string => params[:inhaltsstoff][ih_key], :language => 'DE')
			fbi = FoodAndBeverageIngredient.new(:sequence => ih_key)
			fbi.food_and_beverage_ingredient_names.push(fbin)
			fbi.country_code_type = CountryCodeType.where(:string => 'DE').first_or_create
			fabii.food_and_beverage_ingredients.push(fbi)
		end

		pqi[:percentage_of_alcohol_by_volume] = params[:alkoholgehalt]

		pqi.save!
		fabii.save!
		bi.save!
		pdr.save!
		product.save!
	end

	def extend_product_information_and_save(product)
		present = ProductName.where(["string = '%s'", product[:name_DE]])

		unless present.length == 0
			@errors << 'Product ' + product[:name_DE] + ' already inserted'
			return
		end

		gtin = generate_gtin

		product.merge!({
			:gtin => gtin,
			:infourl_WEBSITE => 'http://eta-ori.net:8080/item.xml?gtin=' + gtin.to_s,
			:bildurl_PRODUCT_LABEL_IMAGE => 'http://eta-ori.net:8080/assets/products/' + gtin.to_s + '.jpg'
		})

		begin
			save_db(product)
		rescue Exception => e
			@errors << 'Storing %s in the database resulted in an error' % product[:name_DE]
			@errors << e
		end
	end

	def fill_db
		@errors = []
		@status = []

		product = {
			:variante => 'Duff Klassisch',
			:name_DE => 'Pils',
			:name_EN => 'Pilsner',
			:regname_DE => 'Untergäriges Bier',
			:regname_EN => 'Bottom-fermented beer',
			:cmd_DE => 'Duff Bier für mich, Duff Bier für dich, ich trinke Duff, ganz genüsslich',
			:cmd_EN => 'Duff beer for me, Duff beer for you, I have a Duff, you have one too',
			:inhaltsangabe => 'Malz mit Hopfen gekocht und mit verschiedenen Hefekulturen zugesetzt.',
			:alkoholgehalt => 5
		}

		product[:inhaltsstoff] = {
			'1' => 'Pilsener Malz',
			'2' => 'Wyeast Hefe',
			'3' => 'Hallertaler Magnum',
			'4' => 'Hallertaler Perle'
		}

		extend_product_information_and_save(product)

		product = {
			:variante => 'Duff Klassisch',
			:name_DE => 'Pils Alkoholfrei',
			:name_EN => 'Pilsner light',
			:regname_DE => 'Untergäriges alkoholfreies Bier',
			:regname_EN => 'Bottom-fermented non-alcoholic beer',
			:cmd_DE => 'Drink and Drive',
			:cmd_EN => 'Drink and Drive',
			:inhaltsangabe => 'Malz mit Hopfen gekocht, Alkohol entzogen und mit verschiedenen Hefekulturen zugesetzt',
			:alkoholgehalt => 0
		}

		product[:inhaltsstoff] = {
			'1' => 'Pilsener Malz',
			'2' => 'Wyeast Hefe',
			'3' => 'Hallertaler Magnum',
			'4' => 'Hallertaler Perle'
		}

		extend_product_information_and_save(product)

		product = {
			:variante => 'Duff Klassisch',
			:name_DE => 'Radler',
			:name_EN => 'Radler',
			:regname_DE => 'Untergäriges Bier mit Zitronenlimonade',
			:regname_EN => 'Bottom-fermented beer with lemonade',
			:cmd_DE => 'Zielgeraden Radler',
			:cmd_EN => '',
			:inhaltsangabe => 'Malz mit Hopfen gekocht, mit verschiedenen Hefekulturen zugesetzt und Zitronenlimonade beigefügt.',
			:alkoholgehalt => 2.5
		}

		product[:inhaltsstoff] = {
			'1' => 'Pilsener Malz',
			'2' => 'Wyeast Hefe',
			'3' => 'Hallertaler Magnum',
			'4' => 'Hallertaler Perle',
			'5' => 'Zitronenlimonade'
		}

		extend_product_information_and_save(product)

		product = {
			:variante => 'Duff Klassisch',
			:name_DE => 'Radler Alkoholfrei',
			:name_EN => 'Radler Non-Alcoholic',
			:regname_DE => 'Untergäriges alkoholfreies Bier mit Zitronenlimonade',
			:regname_EN => 'Bottom-fermented non-alcoholic beer with lemonade',
			:cmd_DE => 'Gewinner Radler',
			:cmd_EN => '',
			:inhaltsangabe => 'Malz mit Hopfen gekocht, Alkohol entzogen, mit verschiedenen Hefekulturen zugesetzt und Zitronenlimonade beigefügt.',
			:alkoholgehalt => 0
		}

		product[:inhaltsstoff] = {
			'1' => 'Pilsener Malz',
			'2' => 'Wyeast Hefe',
			'3' => 'Hallertaler Magnum',
			'4' => 'Hallertaler Perle',
			'5' => 'Zitronenlimonade'
		}

		extend_product_information_and_save(product)

		product = {
			:variante => 'Duff Klassisch',
			:name_DE => 'Weizenbier',
			:name_EN => 'Wheat beer',
			:regname_DE => 'Obergäriges Bier',
			:regname_EN => 'Top-fermented beer',
			:cmd_DE => 'Man sieht das Weizen vor lauter Hopfen nicht',
			:cmd_EN => '',
			:inhaltsangabe => 'Malz mit Hopfen gekocht und mit verschiedenen Hefekulturen zugesetzt.',
			:alkoholgehalt => 5.2
		}

		product[:inhaltsstoff] = {
			'1' => 'Münchner Malz',
			'2' => 'Helles Weizenmalz',
			'3' => 'Wyeast Hefe',
			'4' => 'Hallertaler Hersbrucker',
			'5' => 'Hallertaler Perle'
		}

		extend_product_information_and_save(product)

		product = {
			:variante => 'Duff Klassisch',
			:name_DE => 'Weizenbier Alkoholfrei',
			:name_EN => 'Wheat beer light',
			:regname_DE => 'Obergäriges alkoholfreies Bier',
			:regname_EN => 'Top-fermented non-alcoholic beer',
			:cmd_DE => 'Isotonischer',
			:cmd_EN => '',
			:inhaltsangabe => 'Malz mit Hopfen gekocht, Alkohol entzogen und mit verschiedenen Hefekulturen zugesetzt.',
			:alkoholgehalt => 0
		}

		product[:inhaltsstoff] = {
			'1' => 'Münchner Malz',
			'2' => 'Helles Weizenmalz',
			'3' => 'Wyeast Hefe',
			'4' => 'Hallertaler Hersbrucker',
			'5' => 'Hallertaler Perle'
		}

		extend_product_information_and_save(product)

		product = {
			:variante => 'Duff Klassisch',
			:name_DE => 'Altbier',
			:name_EN => 'Alt beer',
			:regname_DE => 'Dunkles obergäriges Bier',
			:regname_EN => 'Dark top-fermented beer',
			:cmd_DE => 'Nicht so alt, nur älter als andere.',
			:cmd_EN => '',
			:inhaltsangabe => 'Malz mit Hopfen gekocht und mit verschiedenen Hefekulturen zugesetzt.',
			:alkoholgehalt => 4.7
		}

		product[:inhaltsstoff] = {
			'1' => 'Münchner Malz',
			'2' => 'Pilsener Malz',
			'3' => 'Helles Weizenmalz',
			'4' => 'Wyeast Hefe',
			'5' => 'Hallertaler Magnum',
			'6' => 'Hallertaler Hersbrucker',
			'7' => 'Farbmalz'
		}

		extend_product_information_and_save(product)

		product = {
			:variante => 'Duff Klassisch',
			:name_DE => 'India Pale Ale',
			:name_EN => 'India Pale Ale',
			:regname_DE => 'Obergäriges Bier',
			:regname_EN => 'Top-fermented beer',
			:cmd_DE => 'Nur Hopfen hält den Seemann wach.',
			:cmd_EN => '',
			:inhaltsangabe => 'Malz mit Hopfen gekocht und mit verschiedenen Hefekulturen zugesetzt.',
			:alkoholgehalt => 6.4
		}

		product[:inhaltsstoff] = {
			'1' => 'Pilsener Malz',
			'2' => 'Münchner Malz',
			'3' => 'Karamellmalz',
			'4' => 'Herkules',
			'5' => 'Citra',
			'6' => 'Cascade',
		}

		extend_product_information_and_save(product)

		product = {
			:variante => 'Duff Klassisch',
			:name_DE => 'Double India Pale Ale',
			:name_EN => 'Double India Pale Ale',
			:regname_DE => 'Obergäriges Bier',
			:regname_EN => 'Top-fermented beer',
			:cmd_DE => 'Mehr Hopfen hält den Seemann wacher.',
			:cmd_EN => '',
			:inhaltsangabe => 'Malz mit Hopfen gekocht und mit verschiedenen Hefekulturen zugesetzt.',
			:alkoholgehalt => 8.3
		}

		product[:inhaltsstoff] = {
			'1' => 'Pilsener Malz',
			'2' => 'Karamellmalz',
			'3' => 'Columbus',
			'4' => 'Chinook',
			'5' => 'Amarillo',
			'6' => 'Simcoe',
		}

		extend_product_information_and_save(product)

		product = {
			:variante => 'Duff Klassisch',
			:name_DE => 'Champagnerweizen',
			:name_EN => 'Champaign wheat beer',
			:regname_DE => 'Obergäriges Bier',
			:regname_EN => 'Top-fermented beer',
			:cmd_DE => 'Bier ist niemals zu edel.',
			:cmd_EN => '',
			:inhaltsangabe => 'Malz mit Hopfen gekocht und mit verschiedenen Hefekulturen zugesetzt.',
			:alkoholgehalt => 6.5
		}

		product[:inhaltsstoff] = {
			'1' => 'Pilsener Malz',
			'2' => 'Helles Weizenmalz',
			'3' => 'Cara Hell',
			'4' => 'Wyeast Hefe',
			'5' => 'Hallertauer Magnum',
			'6' => 'Hallertaler Perle',
			'7' => 'Kitzinger Champagner-Hefe'
		}

		extend_product_information_and_save(product)

		product = {
			:variante => 'Duff Klassisch',
			:name_DE => 'Kölsch',
			:name_EN => 'Kölsch',
			:regname_DE => 'Obergäriges Bier',
			:regname_EN => 'Top-fermented beer',
			:cmd_DE => 'Kleine Gläser, großes Kölsch.',
			:cmd_EN => '',
			:inhaltsangabe => 'Malz mit Hopfen gekocht und mit verschiedenen Hefekulturen zugesetzt.',
			:alkoholgehalt => 4.8
		}

		product[:inhaltsstoff] = {
			'1' => 'Pilsener Malz',
			'2' => 'Cara Hell',
			'3' => 'Wyeast Hefe',
			'4' => 'Northern Brewer',
			'5' => 'S33 Fermentis'
		}

		extend_product_information_and_save(product)

		respond_to do |format|
			format.html
		end
	end

	def send_da(gtin)
		begin
			require 'net/http'
			require 'digest/hmac'
			require 'builder'
			requri = '/service/v1/product_data/gtin'
			requri += '?clientGln=2865195100007'
			key = '35317388292d936aebdb275e526b7e10b8d10bb4d055a351c823fa59799e1fd7'
			xml = build_xml(Builder::XmlMarkup.new, gtin)
			hmac = Digest::HMAC.hexdigest(requri, key, Digest::SHA256)
			request = Net::HTTP::Post.new(requri + '&mac=' + hmac.upcase, initheader = {'Content-Type' => 'application/xml'})
			request.body = xml
			@response = send_request(request)
		rescue Exception => e
			product = Product.where(:gtin => gtin)
			@errors << 'Getting %s from data aggregator failed' % product[:name_DE]
			@errors << e
		else
			@status << @response.inspect
		end
	end

	def edit_da(gtin)
		begin
			require 'net/http'
			require 'digest/hmac'
			require 'builder'
			requri = '/service/v1/product_data/gtin/%014d' % gtin
			requri += '?clientGln=2865195100007'
			requri += '&targetMarket=276'
			key = '35317388292d936aebdb275e526b7e10b8d10bb4d055a351c823fa59799e1fd7'
			xml = build_xml(Builder::XmlMarkup.new, gtin)
			hmac = Digest::HMAC.hexdigest(requri, key, Digest::SHA256)
			request = Net::HTTP::Put.new(requri + '&mac=' + hmac.upcase, initheader = {'Content-Type' => 'application/xml'})
			request.body = xml
			@response = send_request(request)
		rescue Exception => e
			product = Product.where(:gtin => gtin)
			@errors << 'Updating %s at data aggregator failed' % product[:name_DE]
			@errors << e
		else
			@status << @response.inspect
		end
	end

	def del_da(gtin)
		begin
			require 'net/http'
			require 'digest/hmac'
			require 'builder'
			requri = '/service/v1/product_data/gtin/%014d' % gtin
			requri += '?clientGln=2865195100007'
			requri += '&targetMarket=276'
			key = '35317388292d936aebdb275e526b7e10b8d10bb4d055a351c823fa59799e1fd7'
			hmac = Digest::HMAC.hexdigest(requri, key, Digest::SHA256)
			request = Net::HTTP::Delete.new(requri + '&mac=' + hmac.upcase)
			@response = send_request(request)
		rescue Exception => e
			product = Product.where(:gtin => gtin)
			@errors << 'Deleting %s at data aggregator failed' % product[:name_DE]
			@errors << e
		else
			@status << response.inspect
		end
	end

	def send_all_da
		products = Product.select(:gtin)

		if not products.nil?
			products.each do |pr|
				send_da(pr[:gtin])
			end
		end
	end

	def del_all_da
		products = Product.select(:gtin)

		if not products.nil?
			products.each do |pr|
				del_da(pr[:gtin])
			end
		end
	end

	def get
		@errors = []
		@status = []

		begin
			require 'net/http'
			require 'uri'
			require 'digest/hmac'
			requri = '/service/v1/product_data/gtin/%014d' % params[:gtin]
			requri += '?clientGln=2865195100007'
			requri += '&targetMarket=276'
			key = '35317388292d936aebdb275e526b7e10b8d10bb4d055a351c823fa59799e1fd7'
			hmac = Digest::HMAC.hexdigest(requri, key, Digest::SHA256)
			request = Net::HTTP::Get.new(requri + '&mac=' + hmac.upcase)
			@response = send_request(request)
		rescue Exception => e
			@errors << 'Getting %s from data aggregator failed' % product[:name_DE]
			@errors << e
		else
			@status << @response.inspect
		end

		respond_to do |format|
			if params.has_key? :raw
				format.xml
			else
				format.html
			end
		end
	end

	def maintenance
		@products = Product.all
		@edit_product = Product.where(:gtin => params[:gtin]).first
		@errors = []
		@status = []

		if request.post?
			begin
				if params[:edit] == 'yes'
					update_db(params)
				elsif params[:add] == 'yes'
					save_db(params)
				elsif params[:del] == 'yes'
					raise Exception.new("Deleting from database not supported yet.");
				elsif params[:da_send] == 'yes'
					send_da(params[:gtin])
				elsif params[:da_edit] == 'yes'
					edit_da(params[:gtin])
				elsif params[:da_del] == 'yes'
					del_da(params[:gtin])
				elsif params[:da_send_all] == 'yes'
					send_all_da
				elsif params[:da_del_all] == 'yes'
					del_all_da
				end
			rescue Exception => e
				@errors << e
			end
		end

		if @edit_product.nil?
			@edit_product = ExampleProduct.new(generate_gtin)
		end

		@edit_bi = @edit_product.product_data_records[0].basic_product_informations[0]
		@edit_fabii = @edit_product.product_data_records[0].food_and_beverage_ingredient_informations[0]
		@edit_pqi = @edit_product.product_data_records[0].product_quantity_informations[0]

		respond_to do |format|
			format.html
		end
	end

	def build_xml(xml, gtin)
		product = Product.where(gtin: gtin).first
		if product.nil?
			product = ExampleProduct.new(gtin)
		end
		xml.instruct! :xml, :version => '1.0', :encoding => 'UTF-8'
		xml.pd(:productData,
		       'xsi:schemaLocation' => 'urn:gs1:tsd:product_data:xsd:1 tsd/ProductData.xsd',
		       'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance',
		       'xmlns:pd' => 'urn:gs1:tsd:product_data:xsd:1') do
			xml.gtin ("%014d" % product[:gtin])
			xml.comment! 'see http://en.wikipedia.org/wiki/ISO_3166-1_numeric'
			xml.targetMarket product.target_market[:string]
			xml.informationProviderGLN ("%013d" % product[:provider_gln])
			xml.informationProviderName product[:provider_name]
			xml.comment! 'see http://www.w3schools.com/schema/schema_dtypes_date.asp (Duration DataType)'
			xml.timeToLive product[:ttl]

			product.product_data_records.each do |pdr|
				xml.productDataRecord do
					vdesc = pdr.production_variant_description
					xml.productionVariantDescription(vdesc[:string], 'languageCode' => vdesc[:language])

					xml.productionVariantEffectiveDateTime pdr[:variant_effective_datetime]

					# MODULES START HERE
					pdr.basic_product_informations.each do |bi|
						xml.module do
							xml.bpim(:basicProductInformationModule,
							         'xsi:schemaLocation' => 'urn:gs1:tsd:basic_product_information_module:xsd:1 tsd/BasicProductInformationModule.xsd',
							         'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance',
							         'xmlns:bpim' => 'urn:gs1:tsd:basic_product_information_module:xsd:1') do
								bi.product_names.each do |pn|
									xml.productName(pn[:string], 'languageCode' => pn[:language])
								end

								bi.consumer_marketing_descriptions.each do |cmd|
									xml.consumerMarketingDescription(cmd[:string], 'languageCode' => cmd[:language])
								end

								xml.comment! 'see http://www.gs1.org/1/productssolutions/gdsn/gpc/browser/index.html'
								xml.gpcCategoryCode bi[:gpc_category_code]

								xml.comment! 'regulated description according to Los-Kennzeichnungs-Verordnung (Artikel 3)'
								bi.regulated_product_names.each do |rpn|
									xml.regulatedProductName(rpn[:string], 'languageCode' => rpn[:language])
								end

								xml.brandNameInformation do
									xml.brandName bi.brand_name_information.brand_name_information_local[:string]
								end

								bi.product_information_links.each do |pil|
									xml.productInformationLink do
										xml.url pil[:url]
										xml.comment! 'http://apps.gs1.org/GDD/Pages/clDetails.aspx?semanticURN=urn:gs1:gdd:cl:TSD_ProductInformationTypeCode&release=1'
										xml.productInformationTypeCode pil.product_information_type_code_type[:string]
										xml.comment! 'language used on the website'
										xml.languageCode pil.language_type_code_type[:string]
									end
								end

								bi.image_links.each do |il|
									xml.imageLink do
										xml.url il[:url]
										xml.comment! 'see http://apps.gs1.org/GDD/Pages/clDetails.aspx?semanticURN=urn:gs1:gdd:cl:TSD_ImageTypeCode&release=1'
										xml.imageTypeCode il.image_type_code_type[:string]
										xml.imagePixelHeight il[:height]
										xml.imagePixelWidth il[:width]
										xml.comment! 'see http://www.gs1.org/docs/gsmp/eancom/2012/ean02s4/part3/dc313.htm'
										xml.fileSize(il.measurement_type[:value], 'measurementUnitCode' => il.measurement_type[:unit_code])
									end
								end

								bi.packaging_signature_lines.each do |psl|
									xml.packagingSignatureLine do
										xml.comment! 'see http://apps.gs1.org/GDD/Pages/clDetails.aspx?semanticURN=urn:gs1:gdd:cl:TSD_PartyContactRoleCode&release=1'
										xml.partyContactRoleCode(psl.party_contact_role_code_type[:string])
										xml.partyContactName(psl[:contact_name])
										xml.partyContactAddress(psl[:contact_address])
										xml.gln(psl[:gln])
										psl.communication_channel_types.each do |cc|
											xml.communicationChannel do
												xml.communicationChannelCode(cc.communication_channel_code_type[:string])
												xml.communicationValue(cc[:value])
												xml.communicationChannelName(cc[:name]) unless cc[:name].nil?
											end
										end
									end
								end
							end
						end

						pdr.food_and_beverage_ingredient_informations.each do |f|
							xml.module do
								xml.fabiim(:foodAndBeverageIngredientInformationModule,
									         'xsi:schemaLocation' => 'urn:gs1:tsd:food_and_beverage_information_module:xsd:1 tsd/FoodAndBeverageIngredientInformationModule.xsd',
									         'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance',
									         'xmlns:fabiim' => 'urn:gs1:tsd:food_and_beverage_information_module:xsd:1') do
									f.food_and_beverage_ingredient_statements.each do |fs|
										xml.ingredientStatement(fs[:string], 'languageCode' => fs[:language])
									end
									f.food_and_beverage_ingredients.each do |fi|
										xml.foodAndBeverageIngredient do
											fi.food_and_beverage_ingredient_names.each do |fin|
												xml.ingredientName(fin[:string], 'languageCode' => fin[:language])
											end
											xml.ingredientSequence(fi[:sequence])
											xml.ingredientCountryOfOriginCode(fi.country_code_type[:string])
										end
									end
								end
							end
						end

						pdr.product_quantity_informations.each do |pq|
							xml.module do
								xml.pqim(:productQuantityInformationModule,
									         'xsi:schemaLocation' => 'urn:gs1:tsd:product_quantity_information_module:xsd:1 tsd/ProductQuantityInformationModule.xsd',
									         'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance',
									         'xmlns:pqim' => 'urn:gs1:tsd:product_quantity_information_module:xsd:1') do
									xml.netContent(pq.measurement_type[:value], 'measurementUnitCode' => pq.measurement_type[:unit_code])
									xml.percentageOfAlcoholByVolume pq[:percentage_of_alcohol_by_volume]
								end
							end
						end
					end
				end
			end
		end
	end

	helper_method :build_xml
end
