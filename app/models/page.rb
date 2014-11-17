# encoding: utf-8
class Page < ActiveRecord::Base

  attr_accessible :name, :title, :content, :parent_url
  attr_readonly :url_downcase

  include ActiveModel::Validations
  validates_with PageValidator

  validates :title, :presence => true
  validates :url, :presence => true, :format => {:with => /^[\p{Cyrillic}\w\/]+$/i}
  validates :parent_url, :format => {:with => /^[\p{Cyrillic}\w\/]*$/i}
  validates :name, :presence => true, :format => {:with => /^[\p{Cyrillic}\w]+$/i}
  validates :url_downcase, :presence => true, :format => {:with => /^[\p{Cyrillic}\w\/]+$/i}, :uniqueness => true

  before_validation do
    self.url_downcase
  end

  def level
    self.url.count '/'
  end

  def url_downcase
    if self.url.nil?
      nil
    else
      write_attribute(:url_downcase, self.url.mb_chars.downcase)
    end
  end

  def u(*args)
    ERB::Util.url_encode(*args)
  end


  def encoded_url
    url_parts = self.url.split '/', -1
    url_parts.map! do |url_part|
      u(url_part)
    end
    url_parts.join '/'
  end

  def url
    if self.parent_url.nil? or self.parent_url.empty?
      self.name
    else
      self.parent_url + '/' + self.name unless self.name.nil?
    end
  end

  def url=(url)
    url_parts = url.split '/', -1
    level = url_parts.count
    self.parent_url = url_parts[0...level-1].join '/'
    self.name = url_parts[level-1]
    self.url
  end

  def parent_name
    parent_url_parts = self.parent_url.split '/', -1
    parent_level = parent_url_parts.count
    parent_url_parts[parent_level-1]
  end

  def parent_parent_url
    parent_url_parts = self.parent_url.split '/', -1
    parent_level = parent_url_parts.count
    parent_url_parts[0...parent_level-1].join '/'
  end

  def parent
    if @parent.nil?
      unless self.parent_url.nil?
        @parent = Page.find_by_url_downcase self.parent_url.mb_chars.downcase
      end
    end
    @parent
  end

  private

end