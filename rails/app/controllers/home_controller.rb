class HomeController < ApplicationController
  def index
    object = Product.new(:gtin => 2865195100017, :target_market => 278, :provider_gln => 286519510001, :provider_name => 'Duff Brewery', :ttl => 'P1D', :variant_desc => 'Duff Klassisch', :variant_dtime => '2014-01-01T00:00:00Z')
    object.save
    respond_to do |format|
      format.html
    end
  end

  def items
    @code = 'success'
    respond_to do |format|
      format.xml
      #render :layout => false
    end
  end
end
