module SitePrism
  class Page
    def self.inherited(subclass)
      SitePrismSubclass << subclass
    end

    def load_page(expansion_or_html = {})
      if expansion_or_html.is_a? String
        @page = Capybara.string(expansion_or_html)
        puts "DEBUG: Visiting URL → #{expanded_url}"
      else
        expanded_url = url(expansion_or_html)
        puts "DEBUG: Visiting URL → #{expanded_url}"
        raise SitePrism::NoUrlForPage if expanded_url.nil?
        visit expanded_url
        puts "DEBUG: Visiting URL → #{expanded_url}"
      end
    end
  end
end
