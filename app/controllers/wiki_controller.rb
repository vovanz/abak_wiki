class WikiController < ApplicationController
  before_filter do
    @page_title = 'Abak wiki'
  end

  caches_page :tree, :view

  # Expire all affected pages
  # @param [String] url
  def expire_by_page_url(url)
    expire_page '/' + url
  end

  def tree
    @pages = Page.all :order => :url_downcase, :select => 'name, title, parent_url'
  end

  def view
    @page = Page.find_by_url_downcase params[:url].mb_chars.downcase

    if @page.nil?
      @page = Page.new
      @page.url = params[:url]
      render :template =>  'wiki/no_page', :status => 404
    else
      # consider urls case-insensitive (don't allow urls that differ only by case), but redirect to correct variant
      unless @page.url == params[:url]
        redirect_to '/' + @page.encoded_url, :status => 301 # 301 redirect will be cached by browser
      end

      @page_title + ': ' + @page.title
    end
  end

  def add
    @page = Page.new :parent_url => params[:parent_url]
    unless params[:page].nil?
      @page.assign_attributes params[:page]
    end
    if @page.save
      expire_page '/'
      expire_by_page_url(@page.encoded_url)
      redirect_to '/' + @page.encoded_url
    else
      unless request.post?
        @page.errors.clear
      end
      @page.name = params[:name] unless params[:name].nil? or params[:name].empty?
    end
    if not @page.parent_url.empty? and @page.parent.nil?
      render :template =>  'wiki/no_parent', :status => 404
    end
  end

  def edit
    @page = Page.find_by_url_downcase params[:url].mb_chars.downcase
    if @page.nil?
      @page = Page.new
      @page.url = params[:url]
      render :template =>  'wiki/no_page', :status => 404
    else
      unless @page.url == params[:url]
        redirect_to '/' + @page.encoded_url + '/edit', :status => 301 # 301 redirect will be cached by browser
      end
      unless params[:page].nil?
        @page.assign_attributes params[:page]
      end
      if @page.save and request.put?
        expire_page '/'
        expire_by_page_url(@page.encoded_url)
        redirect_to '/' + @page.encoded_url
      else
        @page.name = params[:name] unless params[:name].nil? or params[:name].empty?
      end
    end
  end

end
