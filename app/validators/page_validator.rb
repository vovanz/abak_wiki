class PageValidator < ActiveModel::Validator
  def validate(page)
    check_special = self.is_special(page.name)
    if check_special
      page.errors[:name] << "Name cant`t be equal to '#{check_special}'"
    end
  end

  def is_special(name)
    unless name.nil?
      special_list = %w(add edit 500.html favicon.ico robots.txt index index.html assets) #disallow creating pages with such names
      special_list.each do |special|
        if name.mb_chars.downcase == special
          return special
        end
      end
    end
    false
  end
end