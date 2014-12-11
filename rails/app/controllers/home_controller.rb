class HomeController < ApplicationController
  def index
  end

  def items
    @code = 'success'
    respond_to do |format|
      format.xml
      #render :layout => false
    end
  end
end
