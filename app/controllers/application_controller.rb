class ApplicationController < ActionController::Base
  attr_accessor :page_title
  before_filter do
    @page_title = ''
  end

  protect_from_forgery
end
