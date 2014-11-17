# encoding: utf-8
module WikiHelper
  class Markup
    def self.markup(str)
      str = str.gsub /\*\*(.+?)\*\*/i, '<b>\1</b>'
      str = str.gsub /\\\\(.+?)\\\\/i, '<i>\1</i>'
      str = str.gsub /\(\(([\p{Cyrillic}\w][\p{Cyrillic}\w\/]+?)\s+(.*?)\)\)/i do |match|
        href = Regexp.last_match[1]
        s = Regexp.last_match[2]
        url_parts = href.split '/'
        url_parts.map! do |url_part|
          if url_part.match /\p{Cyrillic}/
            ERB::Util::url_encode(url_part)
          else
            url_part
          end
        end
        href = '/' << url_parts.join('/')
        "<a href=\"#{href}\">#{s}</a>"
      end
    end
  end
end
