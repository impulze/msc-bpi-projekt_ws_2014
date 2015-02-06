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
					return {:url => 'http://eta-ori.net:8080/items.xml?gtin=' + @gtin.to_s}[x]
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
	def index
		respond_to do |format|
			format.html
		end
	end

	def items
		respond_to do |format|
			format.xml
		end
	end

	def save_db(params)
		require 'rmagick'
		require 'open-uri'
		gtin = params[:gtin]

		tm = TargetMarket.where(:string => 278).first_or_create
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
		imgstream = open(imgurl)
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
		psl = PackagingSignatureLine.new(:contact_name => 'Duff Brewery', :contact_address => 'Elbchaussee 111, 20095 Hamburg', :gln => @gln)
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
		p = Product.new(:gtin => gtin, :provider_gln => @gln, :provider_name => 'Duff Brewery', :ttl => 'P1D')
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

	def generate_gtin
		max = Product.maximum(:gtin)

		if max.nil?
			num = '0' + (@gln + 1).to_s
		else
		        current_max = max.to_s[0..-2].to_i
			next_max = current_max + 1
			num = '0' + next_max.to_s
		end

		check = -3 * (num[0].to_i + num[2].to_i + num[4].to_i + num[6].to_i + num[8].to_i + num[10].to_i + num[12].to_i)
		check -= (num[1].to_i + num[3].to_i + num[5].to_i + num[7].to_i + num[9].to_i + num[11].to_i)
		check %= 10

		return num + check.to_s
	end

	def save_product(product)
		present = ProductName.where(:string => product[:name_DE])

		if present.length == 1
			@errors << 'Product ' + product[:name_DE] + ' already inserted'
			return
		end

		gtin = generate_gtin

		new_product = {
			:gtin => gtin,
			:variante => product[:variante],
			:name_DE => product[:name_DE],
			:name_EN => product[:name_EN],
			:regname_DE => product[:regname_DE],
			:regname_EN => product[:regname_EN],
			:cmd_DE => product[:cmd_DE],
			:cmd_EN => product[:cmd_EN],
			:infourl_WEBSITE => 'http://eta-ori.net:8080/items.xml?gtin=' + gtin.to_s,
			#:bildurl_PRODUCT_LABEL_IMAGE => 'http://eta-ori.net:8080/assets/' + gtin.to_s + '.jpg',
			:bildurl_PRODUCT_LABEL_IMAGE => 'http://upload.wikimedia.org/wikipedia/commons/0/07/AKE_Duff_Beer_IMG_5244_edit.jpg',
			:inhaltsangabe => product[:inhaltsangabe],
			:alkoholgehalt => product[:alkoholgehalt],
		}

		new_product[:inhaltsstoff] = { }

		product[:inhaltsstoff].keys.each do |ih_key|
			new_product[:inhaltsstoff][ih_key] = product[:inhaltsstoff][ih_key]
		end

		save_db(new_product)
	end

	def fill_db
		@errors = []
		@gln = 286519510000

		product = {
			:variante => 'Duff Klassisch',
			:name_DE => 'Altbier',
			:name_EN => 'Alt beer',
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

		save_product(product)

		product = {
			:variante => 'Duff Klassisch',
			:name_DE => 'Altbier Alkoholfrei',
			:name_EN => 'Alt beer light',
			:regname_DE => 'Untergäriges Bier',
			:regname_EN => 'Bottom-fermented beer',
			:cmd_DE => 'Drink and Drive',
			:cmd_EN => 'Drink and Drive',
			:inhaltsangabe => 'Malz mit Hopfen gekocht und mit verschiedenen Hefekulturen zugesetzt. Alkoholfrei.',
			:alkoholgehalt => 0
		}

		product[:inhaltsstoff] = {
			'1' => 'Pilsener Malz',
			'2' => 'Wyeast Hefe',
			'3' => 'Hallertaler Magnum',
			'4' => 'Hallertaler Perle'
		}

		save_product(product)

		product = {
			:variante => 'Duff Klassisch',
			:name_DE => 'Radler',
			:name_EN => 'Radler',
			:regname_DE => 'Untergäriges Bier mit Zitronenlimonate',
			:regname_EN => '',
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

		save_product(product)

		respond_to do |format|
			format.html { render "index" }
		end
	end

	def maintenance
		@products = Product.all
		@edit_product = Product.where(:gtin => params[:gtin]).first
		@errors = []
		@gln = 286519510000

		if request.post?
			#begin
				if params[:update] == 'yes'
					update_db(params)
				else
					save_db(params)
				end
			#rescue Exception => e
			#	@errors << e
			#end
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
end
