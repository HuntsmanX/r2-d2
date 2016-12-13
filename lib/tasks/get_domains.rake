namespace :get_domains do
  desc "Grep all domain's name"
  task get_namecheap_domains: :environment do
    page = Nokogiri::HTML(RestClient.get('https://www.namecheap.com/domains.aspx#domain_tab_pricing'))
    domain_elements = page.css('div.domain')
    tlds = domain_elements.map{ |page_element| page_element.children.children.first.to_s.tr('.*','') }
  end

end
