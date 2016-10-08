require 'open-uri'
require 'nokogiri'
require 'csv'
require 'mechanize'
require 'open_uri_w_redirect_to_https'

$demo = "ja"

class Crawl
  


def rewe_rot
    @rewe = Shop.find_or_initialize_by(id: 1 ,name: "REWE", shop_logo: "https://www.weinfreunde.de/images/logo-weinfreunde.png", 
    versandkosten: 5.95, 
    mindest_bestellmenge: 0, 
    versandkostenfrei_ab_betrag: 59 )
       @rewe.save
    
    inhalt=[]   
    name = []
    product_url = []
    image_url = []
    price = []
    shop = []
    prod_mhd = []
    price_per_litre_string = []
    vintage = []
    
    if $demo == "ja"  
        $seiten = 1
    else
        $seiten = 50
    end
        $seiten.times do |d|
        url ="https://www.weinfreunde.de/weine-bestellen/?pagesize=12&sort=priceASC&allwines=rot&page=#{d+1}"
        page = Nokogiri::HTML(open(url))
        
        #price per litre as string
         page.css('.rwf-article-info').each do |line|
           line = line.text
           line = line.gsub("\n                    ","")
            line = line.gsub("\n                ","")
            if line.include? "\n"
              p "nope"
            else
              line = line[/\(.*?\)/]
              line = line.gsub("(","")
              line = line.gsub(")","")
              p line
              price_per_litre_string << line
            end
        end
        
        #name
        page.css('div.product-title').each do |line|
           line =  line.text
           line.gsub!('\\',"")
        name << line
        end

        page.css('span.rwf-article-unit-price').each do |line|
            line = line.text
            line.gsub!("\n                        ","")
            line.gsub!("\n                    ","")
            inhalt << line
        end
        
        #product_url
        page.css('div.rwf-po-article-gallery-item.rwf-special-hover.article-item a').map { |link| link['href'] }.each do |line|
        short_url = line
        url ="https://www.weinfreunde.de#{short_url}"
        product_url << url
        end
        
        #image_url
        page.css('div.rwf-imgholder img').map{ |i| i['src'] }.each do |line|
        image_url << line
        end
    
        #price
        page.css('span.rwf-price__amount.text-bold').each do |line|
       price_converted = line.text.sub(",",".")
        price2 = price_converted.sub("€","")
        price << price2
        end
        
        #Vintage      
        page.xpath('//*[@id="product-list-page"]/div[2]/div[3]/div/div[2]/div/div/a/div[3]/div[1]/small').each do |line|
        line = line.text
        if line == ""
           line = "N/A"
           vintage <<  line
        else
            vintage <<  line
        end
        
        p line
        end
        
        
        
           #Shop Logo
        #page.css('div.product-title') do |logo|
         #   logo['class']="rewe-logo"
        # logo= 'https://www.weinfreunde.de/images/logo-weinfreunde.png'
       #  shop_logowert = logo
           
       
     
      #  end
     
        $item_count = product_url.length
            
   end
    # SAVING LOOP   
    $item_count.times do |lo|
        p "update started"
     #   index = lo
        
             
      rewe_wein = @rewe.bottles.find_or_initialize_by(name: name[lo])
         # wein = shop.weins.find_or_initialize_by(id: start_value)
         rewe_wein.inhalt = inhalt[lo]
         rewe_wein.name = name[lo]
         rewe_wein.image_url = image_url[lo]
         rewe_wein.category = "Rotwein"
         #wein.vintage = vintage[i]
         rewe_wein.price = price[lo]
         rewe_wein.vintage = vintage[lo]
         rewe_wein.product_url = product_url[lo]
         rewe_wein.price_per_litre_string = price_per_litre_string[lo]
        # wein.prod_desc = prod_desc[i]
         #wein.prod_title = prod_title[i]
         #wein.prod_geschmack = taste[i]
         #wein.category = category[i]
         #rewe_wein.prod_mhd = prod_mhd[lo]
         #if rewe_wein.exists?(:name => name[lo])
         #    next
        # else
        
        
        
         rewe_wein.save
        # end
    end
         
         
         
       
       # p "reached end of migration"
      #  return true
      #  $already_run = 1
end


def rewe_weiss
    @rewe = Shop.find_or_initialize_by(id: 1 ,name: "REWE", shop_logo: "https://www.weinfreunde.de/images/logo-weinfreunde.png",
    versandkosten: 5.95, 
    mindest_bestellmenge: 0, 
    versandkostenfrei_ab_betrag: 59 )
       @rewe.save
       
    inhalt=[]   
    name = []
    product_url = []
    image_url = []
    price = []
    shop = []
    prod_mhd = []
    price_per_litre_string = [] 
    vintage = []
    
    #15 seiten
    if $demo == "ja"  
    $seiten = 1
    else
        $seiten = 15
    end
    $seiten.times do |d|
        url ="https://www.weinfreunde.de/weisswein-bestellen/?pagesize=36&page=#{d+1}"
        page = Nokogiri::HTML(open(url))

        #name
        page.css('div.product-title').each do |line|
            
        line = line.text
        line = line.gsub!("\"","")
        name << line
        end
        
         #price per litre as string
        page.css('.rwf-article-info').each do |line|
           line = line.text
           line = line.gsub("\n                    ","")
            line = line.gsub("\n                ","")
            if line.include? "\n"
              p "nope"
            else
              line = line[/\(.*?\)/]
              line = line.gsub("(","")
              line = line.gsub(")","")
              p line
              price_per_litre_string << line
            end
        end
        
        #product_url
        page.css('div.rwf-po-article-gallery-item.rwf-special-hover.article-item a').map { |link| link['href'] }.each do |line|
        short_url = line
        url ="https://www.weinfreunde.de#{short_url}"
        product_url << url
        end
        
        #Flascheninhalt
        page.css('span.rwf-article-unit-price').each do |line|
            line = line.text
            line.gsub!("\n                        ","")
            line.gsub!("\n                    ","")
            inhalt << line
        end
        
        #image_url
        page.css('div.rwf-imgholder img').map{ |i| i['src'] }.each do |line|
        image_url << line
        end
    
        #price
        page.css('span.rwf-price__amount.text-bold').each do |line|
       price_converted = line.text.sub(",",".")
        price2 = price_converted.sub("€","")
        price << price2
        end
        
        #Vintage      
        page.xpath('//*[@id="product-list-page"]/div[2]/div[3]/div/div[2]/div/div/a/div[3]/div[1]/small').each do |line|
        line = line.text
        if line == ""
           line = "N/A"
           vintage <<  line
        else
            vintage <<  line
        end
        
        p line
        end
        
        $item_count = product_url.length
            
    end
    # SAVING LOOP   
    $item_count.times do |lo|
        p "update started"
     #   index = lo
        
             
       rewe_wein = @rewe.bottles.find_or_initialize_by(product_url: product_url[lo])
         # wein = shop.weins.find_or_initialize_by(id: start_value)
         rewe_wein.inhalt = inhalt[lo]
         rewe_wein.name = name[lo]
         rewe_wein.image_url = image_url[lo]
         rewe_wein.category = "Weißwein"
         rewe_wein.vintage = vintage[lo]
         rewe_wein.price = price[lo]
         rewe_wein.product_url = product_url[lo]
         rewe_wein.price_per_litre_string = price_per_litre_string[lo]
        # wein.prod_desc = prod_desc[i]
         #wein.prod_title = prod_title[i]
         #wein.prod_geschmack = taste[i]
         #wein.category = category[i]
         #rewe_wein.prod_mhd = prod_mhd[lo]
         #if rewe_wein.exists?(:name => name[lo])
         #    next
        # else
        
        
        
         rewe_wein.save
        # end
    end
         
         
         
       
       # p "reached end of migration"
      #  return true
      #  $already_run = 1
end

#DELINERO SHOP    
def delinero_rot
    @delinero = Shop.find_or_initialize_by(id: 2, name: "Delinero", shop_logo: "https://www.delinero.de//skin/frontend/default/gourmet24/images/delinero_logo.png", versandkosten: 5.90, 
    mindest_bestellmenge: 0, 
    versandkostenfrei_ab_betrag: 80 )
    @delinero.save
    inhalt = []
    vintage = []
    prod_desc = []
    price = []
    prod_title =[]
    taste =[]
    category = []
    prod_mhd = []
    name = []
    product_url = []
    image_url = []
    price_per_litre_string = []
     #78 pages in total
    
    if $demo == "ja"  
    $seiten = 1
    else
        $seiten = 78
    end
    $seiten.times do |d|
        p d
        url ="https://www.delinero.de/wein-rot.html?dir=asc&order=price&p=#{d+1}"
        
        page = Nokogiri::HTML(open(url))
        
        #price per litre as string
        page.css(".base-price").each do |line|
            line = line.text
            price_per_litre_string << line
        end
     
        page.css('div.product-info h2.product-name a').map{ |i| i['href'] }.each do |line|  
            product_url << line
        end
       
        page.css('h2.product-name a').each do |line|
        name << line.text
        end
                    
        page.xpath('/html/body/div[2]/div/div[2]/div/div/div[1]/div[2]/div[2]/div/div[1]/h2/span').each do |line|
            line = line.text
            inhalt << line
        end
        
       
        page.css('div.col4-set.product-overview-grid img').map{ |i| i['src'] }.each do |line|
        image_url << line
        end
        
            
            
    end
    
    
    product_url.length.times do |site|
      produkt_seite = Nokogiri::HTML(open(product_url[site]))
      
        p site
            #prod_desc << produkt_seite.css('div.std p').text
        
        #produkt_seite.css('div.col4-set.product-overview-grid img').each do     
            if produkt_seite.at_css('div.p-right-content div.price-box span.regular-price span.price') 
                produkt_seite.css('div.p-right-content div.price-box span.regular-price span.price').each do |line|
                    price_converted = line.text.gsub(/[[:space:]]/, "")
                    price3 = price_converted.sub(",",".")
                    price2 =price3.sub("EUR","")
                    price << price2
                    
                end
            else
                produkt_seite.css('div.p-right-content div.price-box p.special-price span.price').each do |specprice|
                    price_converted = specprice.text.gsub(/[[:space:]]/, "")
                    price3 = price_converted.sub(",",".")
                    price2 = price3.sub("EUR","")
                    price << price2
                end
            end
        #end
        #vintage found in name?
    #    produkt_seite.xpath('//*[@id="product_addtocart_form"]/div[2]/div[2]/h1').each do |line|
       #    line = line.text
      #      p line
     #       if !( line =~ /\b\d{4}\b/).nil?
    #            line = line.scan(/\b\d{4}\b/)
                #    vintage << line
               #     $vintage_found = 1
              #      p $vintage_found
             #       p line
            #        p "FOUND!"
           # elsif $vintage_found == 0
            
               #produkt_seite.xpath('//*[@id="product_accordion_cms_contents"]/div/div/div[1]/em').each  do |line2|
                produkt_seite.xpath('//*[@id="product_addtocart_form"]/div[2]/div[2]/h1').each do |line2|
                       line2 = line2.text
                            p "second check:"
                               line2 = line2.scan(/\d{4}/)
                               line2 = line2[0]
                            if line2 != nil
                                vintage << line2
                                p line2
                            end 
                        if line2 == nil
                               line2 = "n/a"
                               p line2
                                vintage << line2
                         
                        end
                end
          #  end
       # end
    end 
    
    
    count =  product_url.length  
   # @start_value = (Bottle.count('id', :distinct => false))
        
    count.times do |i|
        p i 
      #  index = @start_value + i
        delinero_wein = @delinero.bottles.find_or_initialize_by(product_url: product_url[i])
        delinero_wein.name = name[i]    
        delinero_wein.category = "Rotwein"
        delinero_wein.image_url = image_url[i]
        delinero_wein.product_url = product_url[i]
        delinero_wein.price = price[i]
        delinero_wein.inhalt = inhalt[i]
        delinero_wein.price_per_litre_string = price_per_litre_string[i]
        delinero_wein.vintage = vintage[i]
      #  delinero_wein.prod_mhd = prod_mhd[i]
     #   if @delinero.weins.exists?(name: name[i]) 
          #if @delinero.weins.find_by(:name => name[i]).price == price[i]
           #  next
           #  else
                
           # end
       #     next
      #  else
       delinero_wein.save
     #   end
    end
end

def delinero_weiss
    @delinero = Shop.find_or_initialize_by(id: 2, name: "Delinero", shop_logo: "https://www.delinero.de//skin/frontend/default/gourmet24/images/delinero_logo.png",versandkosten: 5.90, 
    mindest_bestellmenge: 0, 
    versandkostenfrei_ab_betrag: 80 )
    @delinero.save
    
    inhalt = []
    vintage = []
    prod_desc = []
    price = []
    prod_title =[]
    taste =[]
    category = []
    prod_mhd = []
    name = []
    product_url = []
    image_url = []
    price_per_litre_string = []
     #157 pages in total
    
    if $demo == "ja"  
    $seiten = 1
    else
        $seiten = 58
    end
    $seiten.times do |d|
    
        url ="https://www.delinero.de/wein-weiss.html?dir=asc&order=price&p=#{d+1}"
          
        page = Nokogiri::HTML(open(url))
        
        #price per litre as string
        page.css(".base-price").each do |line|
            line = line.text
            price_per_litre_string << line
            p line
        end
     
        page.css('div.product-info h2.product-name a').map{ |i| i['href'] }.each do |line|  
            product_url << line
        end
       
        page.css('h2.product-name a').each do |line|
        name << line.text
        end
                    
        page.xpath('/html/body/div[2]/div/div[2]/div/div/div[1]/div[2]/div[2]/div/div[1]/h2/span').each do |line|
            line = line.text
            inhalt << line
        end
      
       
        page.css('div.col4-set.product-overview-grid img').map{ |i| i['src'] }.each do |line|
        image_url << line
        p line
        end
        
        #     page.css('div.col4-set.product-overview-grid img').each do     
        #     if page.css('div.price-box span.regular-price span.price') 
        #         page.css('div.price-box span.regular-price span.price').each do |line|
        #             price_converted = line.text.gsub(/[[:space:]]/, "")
        #             price3 = price_converted.sub(",",".")
        #             price2 =price3.sub("EUR","")
        #             price << sprintf("€%2.2f", price2)
        #         end
        #     else
        #         page.css('div.price-box p.special-price').each do |specprice|
        #             price_converted = specprice.text.gsub(/[[:space:]]/, "")
        #             price3 = price_converted.sub(",",".")
        #             price2 = price3.sub("EUR","")
        #             price << sprintf("€%2.2f", price2)
        #         end
        #     end
        # end
            
       
        
            
            
    end
    
    
      product_url.length.times do |site|
      produkt_seite = Nokogiri::HTML(open(product_url[site]))
        p site
            #prod_desc << produkt_seite.css('div.std p').text
        
        #produkt_seite.css('div.col4-set.product-overview-grid img').each do     
            if produkt_seite.at_css('div.p-right-content div.price-box span.regular-price span.price') 
                produkt_seite.css('div.p-right-content div.price-box span.regular-price span.price').each do |line|
                    price_converted = line.text.gsub(/[[:space:]]/, "")
                    price3 = price_converted.sub(",",".")
                    price2 =price3.sub("EUR","")
                    price << price2.to_d
                    p price2
                end
            else
                produkt_seite.css('div.p-right-content div.price-box p.special-price span.price').each do |specprice|
                    price_converted = specprice.text.gsub(/[[:space:]]/, "")
                    price3 = price_converted.sub(",",".")
                    price2 = price3.sub("EUR","")
                    price << price2.to_d
                    p price2
                end
            end
          #vintage found in name?
    #    $vintage_found = 0
    #    p $vintage_found
    #    produkt_seite.xpath('//*[@id="product_addtocart_form"]/div[2]/div[2]/h1').each do |line|
            
          #  line = line.text
          #  p line
          #  if line.include? "20" or line.include? "19"
          #      vintage << line.scan(/\d{4}/).first
        ##        $vintage_found = 1
       #         p $vintage_found
      #          p line.scan(/\d{4}/).first
     #       end    
    #    end
            
   # end
                      produkt_seite.xpath('//*[@id="product_addtocart_form"]/div[2]/div[2]/h1').each do |line2|
                       line2 = line2.text
                            p "second check:"
                               line2 = line2.scan(/\d{4}/)
                               line2 = line2[0]
                            if line2 != nil
                                vintage << line2
                                p line2
                            end 
                        if line2 == nil
                               line2 = "n/a"
                               p line2
                                vintage << line2
                         
                        end
                end
          #  end
       # end
    
   end 
    
    
    count =  product_url.length  
   # @start_value = (Bottle.count('id', :distinct => false))
        
    count.times do |i|
      p i
        
      #  index = @start_value + i
        delinero_wein = @delinero.bottles.find_or_initialize_by(product_url: product_url[i])
        delinero_wein.name = name[i]    
        delinero_wein.category = "Weißwein"
        delinero_wein.image_url = image_url[i]
        delinero_wein.product_url = product_url[i]
        delinero_wein.price = price[i]
        delinero_wein.inhalt = inhalt[i]
        delinero_wein.price_per_litre_string = price_per_litre_string[i]
        delinero_wein.vintage = vintage[i]
      #  delinero_wein.prod_mhd = prod_mhd[i]
     #   if @delinero.weins.exists?(name: name[i]) 
          #if @delinero.weins.find_by(:name => name[i]).price == price[i]
           #  next
           #  else
                
           # end
       #     next
      #  else
       delinero_wein.save
     #   end
    end
end


# VINOS.DE SHOP
  #Rotwein
def vinos_rot
    @vinos = Shop.find_or_initialize_by(id: 3, name: "Vinos", shop_logo: "http://www.vinos.de/skin/frontend/d2c/vinos/images/logo.png",
    versandkosten: 0, 
    mindest_bestellmenge: 25, 
    verpackungsrabatt: 0.03,
    mengenrabatt: 0.03,
    mengenrabatt_menge: 18)
    vintage = []
    prod_desc = []
    price = []
    prod_title =[]
    taste =[]
    category = []
    prod_mhd = []
    name = []
    product_url = []
    image_url = []
    inhalt = []
    price_per_litre_string = []
 #50 Seiten im Original - 31.08
    if $demo == "ja"  
    $seiten = 1
    else
        $seiten = 50
    end
    $seiten.times do |d|
    
        url ="http://www.vinos.de/weine/rot/alle?p=#{d+1}"
        page = Nokogiri::HTML(open(url))
        
         
            
        #product_url = []
        page.css('div.module.border-r a').map { |link| link['href'] }.each do |line|
        produkt_link = line   
        product_url << produkt_link
        end
        
        page.css('div.module-media.border-b img').map{ |i| i['src'] }.each do |line|
               
        image_url << line
        end

 end
   
   $item_count2 = product_url.length
   
    product_url.length.times do |site|
        produkt_seite = Nokogiri::HTML(open(product_url[site]))
        
        
            #produkt_seite.css('h3.h1.serif.italic.border-b.padding-b-small').each do |geschmack|
             #   vintage << geschmack.text
            #end
            
            #litre_price_string
            produkt_seite.xpath('//*[@id="product-view"]/div[1]/div/div/div[3]/div[1]/div[2]/div/div/div/span[3]').each do |line|
               
                if line.text.include? "/"
                    line = line.text
                    line = line.gsub!(" /l","")
                    line << " / 1l"
                    price_per_litre_string << line
                end
            end
            
            #vintage           
            produkt_seite.xpath('//*[@id="product-view"]/div[1]/div/div/div[2]/h1/text()[2]').each do |line|
                line = line.text
                line = line.scan(/\d{4}/)
                line = line[0]
               p line
            if line != nil
                vintage << line
            end
            if line.nil?
                vintage << "n/a"
            end
            end 
                
            #inhalt
            produkt_seite.xpath('//*[@id="product-view"]/div[1]/div/div/div[3]/div[1]/div[2]/div/div/div/span/text()').each do |line|
                line = line.text
                if line.include? "Pro Flasche"
                    line = line.gsub("Pro Flasche","")
                    line = line.gsub("(","")
                    line = line.gsub(")","")
                    line = line.gsub("\n                                                                                                                                                                                    ","")
                    line = line.gsub("\n                                                                                    ","")
                    inhalt << line
                else
                end
            end   
            
            desc = produkt_seite.css('div#wineinfo div.column-right p').text
            if desc.empty? 
                desc = produkt_seite.css('div#wineinfo div.column-right').text
                prod_desc << desc
            else
                prod_desc << produkt_seite.css('div#wineinfo div.column-right p').text
            end
        
            produkt_seite.xpath('//dd[4]').each do |title|
                taste << title
            end
            produkt_seite.css('div#wineinfo div.column-right h3').each do |ta|
                name << ta.text
            end
            produkt_seite.css('div#wineinfo div.column-right h3').each do |ta|
                category << 'Weißwein'
            end
            #Shop Logo
            #produkt_seite.css('div.header a.logo img').map{ |i| i['src'] }.each do |line|
            #    shop_logo << line
            #end
             
            produkt_seite.css('div.price-box span.final-price span.price').each do |preis|
                price_converted = preis.text.gsub(/[[:space:]]/, "")
                price2 = price_converted.to_s.gsub!(',', '.')
                price << price2
            end     
            
            #Shop Logo
    end
    
      
    #@vinos.shop_logo = shop_logowert
    #Zählt alle Items des letzten Updates - wird benötigt um den Index für ID zu setzten, um dort fortzuführen wo die letzte migration endete
    
   # @start_value = (Wein.count('id', :distinct => false))
        
    $item_count2.times do |lo|
    p lo
       # index = @start_value + lo
        # p "first run"
   # end
     #  wein = Wein.find_or_initialize_by(id: index, shop_id: 2)
        vinos_wein = @vinos.bottles.find_or_initialize_by(product_url: product_url[lo])
            vinos_wein.name = name[lo]
            vinos_wein.image_url = image_url[lo]
            vinos_wein.price = price[lo]
            vinos_wein.product_url = product_url[lo]
          #  vinos_wein.prod_mhd = prod_mhd[lo]
            vinos_wein.vintage = vintage[lo]
            vinos_wein.inhalt = inhalt[lo]
            vinos_wein.category = "Rotwein"
            vinos_wein.price_per_litre_string = price_per_litre_string[lo]
            vinos_wein.save
            
    end
end

# VINOS.DE SHOP
  #Weißwein
def vinos_weiss
    @vinos = Shop.find_or_initialize_by(id: 3, name: "Vinos", shop_logo: "http://www.vinos.de/skin/frontend/d2c/vinos/images/logo.png",
    versandkosten: 0, 
    mindest_bestellmenge: 25, 
    verpackungsrabatt: 0.03,
    mengenrabatt: 0.03,
    mengenrabatt_menge: 18)
     @vinos.save
    #157 pages in total
    vintage = []
    prod_desc = []
    price = []
    prod_title =[]
    taste =[]
    category = []
    prod_mhd = []
    name = []
    product_url = []
    image_url = []
    inhalt = []
    price_per_litre_string = []
   
    if $demo == "ja"  
    $seiten = 1
    else
        $seiten = 37
    end
    $seiten.times do |d|
    
        url ="http://www.vinos.de/weine/weiss/alle?dir=asc&order=price&p=#{d+1}"
        page = Nokogiri::HTML(open(url))
        
         
            
        #product_url = []
        page.css('div.module.border-r a').map { |link| link['href'] }.each do |line|
        produkt_link = line   
        product_url << produkt_link
        end
        
        page.css('div.module-media.border-b img').map{ |i| i['src'] }.each do |line|
               
        image_url << line
        end

 end
   
   $item_count2 = product_url.length
   
    product_url.length.times do |site|
        produkt_seite = Nokogiri::HTML(open(product_url[site]))
        
        
            #produkt_seite.css('h3.h1.serif.italic.border-b.padding-b-small').each do |geschmack|
             #   vintage << geschmack.text
            #end
                      
            #litre_price_string  //*[@id="product-view"]/div[1]/div/div/div[3]/div[1]/div[2]/div/div/div/span/text()
            produkt_seite.xpath('//*[@id="product-view"]/div[1]/div/div/div[3]/div[1]/div[2]/div/div/div/span').each do |line|
               
                if line.text.include? "/"
                    line = line.text
                    line = line.gsub!(" /l","")
                    line << " / 1l"
                    p line
                    price_per_litre_string << line
                end
            end
            
            #vintage           
            produkt_seite.xpath('//*[@id="product-view"]/div[1]/div/div/div[2]/h1/text()[2]').each do |line|
                line = line.text
                line = line.scan(/\d{4}/)
                line = line[0]
               p line
                vintage << line
            end 
                
                                   
            #inhalt            
            produkt_seite.xpath('//*[@id="product-view"]/div[1]/div/div/div[3]/div[1]/div[2]/div/div/div/span/text()').each do |line|
                line = line.text
                if line.include? "Pro Flasche"
                    line = line.gsub("Pro Flasche","")
                    line = line.gsub("(","")
                    line = line.gsub(")","")
                    line = line.gsub("\n                                                                                                                                                                                    ","")
                    line = line.gsub("\n                                                                                    ","")
                    p line
                    inhalt << line
                else
                    p "nope"
                end
            end    
            
            desc = produkt_seite.css('div#wineinfo div.column-right p').text
            if desc.empty? 
                desc = produkt_seite.css('div#wineinfo div.column-right').text
                prod_desc << desc
            else
                prod_desc << produkt_seite.css('div#wineinfo div.column-right p').text
            end
        
            produkt_seite.xpath('//dd[4]').each do |title|
                taste << title
            end
            produkt_seite.css('div#wineinfo div.column-right h3').each do |ta|
                name << ta.text
            end
            produkt_seite.css('div#wineinfo div.column-right h3').each do |ta|
                category << 'Weißwein'
            end
            #Shop Logo
            #produkt_seite.css('div.header a.logo img').map{ |i| i['src'] }.each do |line|
            #    shop_logo << line
            #end
             
            produkt_seite.css('div.price-box span.final-price span.price').each do |preis|
                price_converted = preis.text.gsub(/[[:space:]]/, "")
                price2 = price_converted.to_s.gsub!(',', '.')
                price << price2
            end     
            
            #Shop Logo
            produkt_seite.css('div.header a.logo img').map{ |i| i['src'] }.each do |line|
                shop_logowert = line
            end
    end
    
      
    #@vinos.shop_logo = shop_logowert
    #Zählt alle Items des letzten Updates - wird benötigt um den Index für ID zu setzten, um dort fortzuführen wo die letzte migration endete
    
   # @start_value = (Wein.count('id', :distinct => false))
        
    $item_count2.times do |lo|
    p lo
       # index = @start_value + lo
        # p "first run"
   # end
     #  wein = Wein.find_or_initialize_by(id: index, shop_id: 2)
        vinos_wein = @vinos.bottles.find_or_initialize_by(name: name[lo])
            vinos_wein.name = name[lo]
            vinos_wein.image_url = image_url[lo]
            vinos_wein.price = price[lo]
            vinos_wein.product_url = product_url[lo]
          #  vinos_wein.prod_mhd = prod_mhd[lo]
            vinos_wein.vintage = vintage[lo]
            vinos_wein.inhalt = inhalt[lo]
            vinos_wein.category = "Weißwein"
            vinos_wein.price_per_litre_string = price_per_litre_string[lo]
            vinos_wein.save
            
    end
end
   
 #HAWESKO
def hawesko_rot              
    @hawesko = Shop.find_or_initialize_by(id: 4, name: "Hawesko", shop_logo: "logo.png",
    versandkosten: 6.90, 
    versandkostenfrei_ab_menge: 24,
    mindest_bestellmenge: 12)
    
    
    vintage = []
    prod_desc = []
    price = []
    prod_title =[]
    taste =[]
    category = []
    prod_mhd = []
    name = []
    product_url = []
    image_url = []
    links = []
    inhalt = []
    price_per_litre_string = []
    $check2 = 0
     #157 pages in total
    #46 - 1.9.2016
    if $demo == "ja"  
    $seiten = 1
    else
        $seiten = 46
    end
    $seiten.times do |d|
    
      
   
        url ="https://www.hawesko.de/rotwein?filters=Color:rot&page=#{d+1}#filter-bar"
        page = Nokogiri::HTML(open(url))
  
        page.xpath('//*[@id="alle_weine"]/div/div/div/a').each do |line|  
            links << "https://www.hawesko.de" + line['href']
        end
    end
        cont = 0
        links.each do |x|
            innerpage = Nokogiri::HTML(open(x))
           # p cont
            cont =  cont + 1
                    product_url << x
      
                   innerpage.xpath(' /html/body/div[1]/div[1]/div[1]/div[4]/div/div[2]/div[3]/div/div[1]/div/div/h1').each do |line|
                        name2 =  line.text
                      #  puts name2
                        p name2
                        name << name2
                    end
                    
                     #vintage
                    $check2 = 0
                    innerpage.css('.description-value').each do |line|
                        line = line.text
                        if line.scan(/\b\d{4}\b/)
                            line = line.scan(/\b\d{4}\b/).first
                                
                                if !line.nil? and line.to_i > 1900 and line.to_i < 2016
                                    p line
                                    $check2 = 1
                                    vintage << line
                                end
                        end 
                    end
                    
                    if $check2 == 0 
                        vintage << "n/a"
                    end
                    
                    innerpage.xpath('//*[@id="sticky-bar-detail"]/div[1]/div[1]/div/div/div[1]/div[2]/div[2]/div/div/span/span').each do |line|
                        line = line.text
                        line.insert(0, '€ ') 
                        line << " / 1l"
                        
                        p line
                        price_per_litre_string << line
                    end
                    
                    #inhalt
                   
                    check = 0
                    innerpage.css('div.description-value').each do |line|
                        line = line.text
                        line = line.gsub!("\n        ","")
                        line = line.gsub!("\n    ","")
                        
                        if line.include? " ml"
                            p line
                            inhalt << line
                            check = 1
                        end
                    end
                    
                    if check == 0
                        inhalt << "n/a"
                    end 
                       
                    innerpage.css('.article.button').each   do |line|
                   price2 = line['data-price']
                    price << price2  
                   end              
                    innerpage.xpath('/html/body/div[1]/div[1]/div[1]/div[4]/div/div[2]/div[2]/div[1]/div/div/picture/img').map{ |i| i['data-src'] }.each  do |line|
                        img =  line
                        p img
                        image_url << img
                    end
                end
                
                
    count =  product_url.length  
        
    count.times do |i|
    
        hawesko_wein = @hawesko.bottles.find_or_initialize_by(product_url: product_url[i])
        hawesko_wein.name = name[i]
        hawesko_wein.image_url = image_url[i]
        hawesko_wein.product_url = product_url[i]
        hawesko_wein.price = price[i]
        hawesko_wein.inhalt = inhalt[i]
        hawesko_wein.price_per_litre_string = price_per_litre_string[i]
        hawesko_wein.category = "Rotwein"
        hawesko_wein.vintage = vintage[i]
        #hawesko_wein.prod_mhd = prod_mhd[i]
        
        hawesko_wein.save
    
    end
end  

def hawesko_weiss              
    @hawesko = Shop.find_or_initialize_by(id: 4, name: "Hawesko", shop_logo: "logo.png",
    versandkosten: 6.90, 
    versandkostenfrei_ab_menge: 24,
    mindest_bestellmenge: 12)
    
    
    vintage = []
    prod_desc = []
    price = []
    prod_title =[]
    taste =[]
    category = []
    prod_mhd = []
    name = []
    product_url = []
    image_url = []
    links = []
    inhalt = []
    price_per_litre_string = []
    $check2 = 0 
    
    #18 Pages Weiss - 1.9.2016
   if $demo == "ja"  
    $seiten = 1
    else
        $seiten = 18
    end
    $seiten.times do |d|
      
                
        url ="https://www.hawesko.de/weisswein?filters=Color:weiss&page=#{d+1}#filter-bar"
               page = Nokogiri::HTML(open(url))
  
        page.xpath('//*[@id="alle_weine"]/div/div/div/a').each do |line|  
            links << "https://www.hawesko.de" + line['href']
        end
    end
        cont = 0
        links.each do |x|
            innerpage = Nokogiri::HTML(open(x))
           # p cont
            cont =  cont + 1
                    product_url << x
      
                   innerpage.xpath(' /html/body/div[1]/div[1]/div[1]/div[2]/div/div/span/text()').each do |line|
                        name2 =  line.text
                      #  puts name2
                        p name2
                        name << name2
                    end
                    
                      #vintage
                    $check2 = 0
                    innerpage.css('.description-value').each do |line|
                        line = line.text
                        if line.scan(/\b\d{4}\b/)
                            line = line.scan(/\b\d{4}\b/).first
                                
                                if !line.nil? and line.to_i > 1900 and line.to_i < 2016
                                    p line
                                    $check2 = 1
                                    vintage << line
                                end
                        end 
                    end
                    
                    if $check2 == 0 
                        vintage << "n/a"
                    end
                    
                          innerpage.xpath('//*[@id="sticky-bar-detail"]/div[1]/div[1]/div/div/div[1]/div[2]/div[2]/div/div/span/span').each do |line|
                        line = line.text
                        line.insert(0, '€ ') 
                        line << " / 1l"
                        
                        p line
                        price_per_litre_string << line
                    end
                    
                    #inhalt
                   
                    check = 0
                    innerpage.css('div.description-value').each do |line|
                        line = line.text
                        line = line.gsub!("\n        ","")
                        line = line.gsub!("\n    ","")
                        
                        if line.include? " ml"
                            p line
                            inhalt << line
                            check = 1
                        end
                    end
                    
                    if check == 0
                        inhalt << "n/a"
                    end 
                       
                   innerpage.css('.article.button').each   do |line|
                   price2 = line['data-price']
                    price << price2   
                   end              
                    innerpage.xpath('/html/body/div[1]/div[1]/div[1]/div[4]/div/div[2]/div[2]/div[1]/div/div/picture/img').map{ |i| i['data-src'] }.each  do |line|
                        img =  line
                        p img
                        image_url << img
                    end
                end
                
                
    count =  product_url.length  
        
    count.times do |i|
    
        hawesko_wein = @hawesko.bottles.find_or_initialize_by(product_url: product_url[i])
        hawesko_wein.name = name[i]
        hawesko_wein.image_url = image_url[i]
        hawesko_wein.product_url = product_url[i]
        hawesko_wein.price = price[i]
        hawesko_wein.inhalt = inhalt[i]
        hawesko_wein.price_per_litre_string = price_per_litre_string[i]
        hawesko_wein.category = "Weißwein"
        hawesko_wein.vintage = vintage[i]
        #hawesko_wein.prod_mhd = prod_mhd[i]
        
        hawesko_wein.save
    
    end
end  

#noch nicht fertig! Shop Versandbedingungen fehlen noch!
def edeka_1
    @edeka = Shop.find_or_initialize_by(id: 5, name: "Edeka",shop_logo: "edeka24.jpg")
    @edeka.save
    
    vintage = []
    prod_desc = []
    price = []
    prod_title =[]
    taste =[]
    category = []
    prod_mhd = []
    name = []
    product_url = []
    image_url = []
    inhalt = []
    price_per_litre_string = []
    $check2 = 0
   
        
        #deutsche weine
        url ="https://www.edeka24.de/Getraenke/Deutsche+Weine/?force_sid=l2tep3m7uche07igtpfio7sh47&ldtype=&_artperpage=100&pgNr=0&cl=alist&searchparam=&cnid=d4b674347abffda7caa0e3f4d813c631"
        page = Nokogiri::HTML(open(url))
    
     p "h1"         
        page.css('.productImage a').each do |line|  
            product_url << line['href']
        end
        
        
     p "h2"  
     $check2 = 0
        page.css('div.product-top-box h2 a span').each do |line|
        name << line.text
        line = line.text
        if line.scan(/\b\d{4}\b/)
                            line = line.scan(/\b\d{4}\b/).first
                                
                                if !line.nil? and line != "" and line.include? "20"
                                    p line
                                    $check2 = 1
                                    vintage << line
                                else
                                    vintage << "n/a"
                                end 
                        
        else
                        vintage << "n/a"
        end
        end
        
        counter = name.length
        
    p "h3"   
        #page.css('.productImage a').each   do |i|
            #mainContent > div.teaserContainer.clearfix > div:nth-child(2) > 
            #mainContent > div.teaserContainer.clearfix > div:nth-child(9) > div.productImage > a > img
    
       # image_url << i
        #end
    p "h4"    
         page.css('.price.roundCorners').each do |preis|
                price_converted = preis.text.gsub(" ", "")
                price2 = price_converted.gsub(',', '.')
                #price2 = price2.sub("€*","")
                 
            price << price2
            
        end 
        
        
       
        
        page.css('.package').each do |line|
            line = line.text
            line = line.gsub!("Inhalt: ","")
            line = line.gsub!(" ltr","")
            line = line.gsub!(" ", "")
            line = line.gsub!("\n", "")
            inhalt << line
        end 
        
       # page.css('pricePerUnit').each do |line|
        #    line = line.text
         #   line = line.gsub!(" €/1 ltr", "")
          #  line = line.gsub!(" ", "")
           # price_per_litre_string << line
        #end
                    
      
    p "h5"        
       
       # name.length.times do |line|
            
     #   category << 'Rotwein'    
      #  prod_mhd << 'https://cdn-1.vetalio.de/media/catalog/product/cache/1/logo/150x100/9df78eab33525d08d6e5fb8d27136e95/e/d/edeka24.png'
    #    end


         #vintage
      
            
 
  
   product_url.each do |y|
            page = Nokogiri::HTML(open(y))
            page.xpath('//*[@id="zoom1"]').each do |line|
                line = line['href']
                image_url << line
            end
            
            page.xpath('//*[@id="productPriceUnit"]').each do |line|
                line = line.text
                line = line.gsub!("(","")
                line = line.gsub!(")","")
                price_per_litre_string << line
            end 
            
   end 
    
    
    
           
    
    count =  product_url.length  
    
    count.times do |i|
    
        delinero_wein = @edeka.bottles.find_or_initialize_by(product_url: product_url[i])
        delinero_wein.name = name[i]
        delinero_wein.image_url = image_url[i]
        delinero_wein.product_url = product_url[i]
        delinero_wein.price = price[i]
        delinero_wein.vintage = vintage[i]
        delinero_wein.inhalt = inhalt[i]
        delinero_wein.category = "Rotwein"
        delinero_wein.price_per_litre_string = price_per_litre_string[i]
        
            
        delinero_wein.save
        
    end
end
#noch nicht fertig! Shop Versandbedingungen fehlen noch!
def edeka_2
     @edeka = Shop.find_or_initialize_by(id: 5, name: "Edeka",shop_logo: "edeka24.jpg")
    @edeka.save
    
    
    
    vintage = []
    prod_desc = []
    price = []
    prod_title =[]
    taste =[]
    category = []
    prod_mhd = []
    name = []
    product_url = []
    image_url = []
    inhalt = []
    price_per_litre_string = []
    $check2 = 0
    
    
        url ="https://www.edeka24.de/index.php?force_sid=939nd3t7dv6il37sat0anbc694&"
        page = Nokogiri::HTML(open(url))
    
    p "h1"         
        page.css('.productImage a').each do |line|  
            product_url << line['href']
        end
        
        
     p "h2"  
     $check2 = 0
        page.css('div.product-top-box h2 a span').each do |line|
        name << line.text
        line = line.text
        if line.scan(/\b\d{4}\b/)
                            line = line.scan(/\b\d{4}\b/).first
                                
                                if !line.nil? and line != "" and line.include? "20"
                                    p line
                                    $check2 = 1
                                    vintage << line
                                else
                                    vintage << "n/a"
                                end 
                        
        else
                        vintage << "n/a"
        end
        end
        
        counter = name.length
        
    p "h3"   
        #page.css('.productImage a').each   do |i|
            #mainContent > div.teaserContainer.clearfix > div:nth-child(2) > 
            #mainContent > div.teaserContainer.clearfix > div:nth-child(9) > div.productImage > a > img
    
       # image_url << i
        #end
    p "h4"    
         page.css('.price.roundCorners').each do |preis|
                price_converted = preis.text.gsub(" ", "")
                price2 = price_converted.gsub(',', '.')
                #price2 = price2.sub("€*","")
                 
            price << price2
            
        end 
        
        
       
        
        page.css('.package').each do |line|
            line = line.text
            line = line.gsub!("Inhalt: ","")
            line = line.gsub!(" ltr","")
            line = line.gsub!(" ", "")
            line = line.gsub!("\n", "")
            inhalt << line
        end 
        
       # page.css('pricePerUnit').each do |line|
        #    line = line.text
         #   line = line.gsub!(" €/1 ltr", "")
          #  line = line.gsub!(" ", "")
           # price_per_litre_string << line
        #end
                    
      
    p "h5"        
       
       # name.length.times do |line|
            
     #   category << 'Rotwein'    
      #  prod_mhd << 'https://cdn-1.vetalio.de/media/catalog/product/cache/1/logo/150x100/9df78eab33525d08d6e5fb8d27136e95/e/d/edeka24.png'
    #    end


         #vintage
      
            
 
  
   product_url.each do |y|
            page = Nokogiri::HTML(open(y))
            page.xpath('//*[@id="zoom1"]').each do |line|
                line = line['href']
                image_url << line
            end
            
            page.xpath('//*[@id="productPriceUnit"]').each do |line|
                line = line.text
                line = line.gsub!("(","")
                line = line.gsub!(")","")
                price_per_litre_string << line
            end 
            
   end 
    
    
    
           
    
    count =  product_url.length  
    
    count.times do |i|
    
        delinero_wein = @edeka.bottles.find_or_initialize_by(product_url: product_url[i])
        delinero_wein.name = name[i]
        delinero_wein.image_url = image_url[i]
        delinero_wein.product_url = product_url[i]
        delinero_wein.price = price[i]
        delinero_wein.vintage = vintage[i]
        delinero_wein.inhalt = inhalt[i]
        delinero_wein.category = "Rotwein"
        delinero_wein.price_per_litre_string = price_per_litre_string[i]
        
            
        delinero_wein.save
        
    end
end

def weinzeche_rot
    @weinzeche = Shop.find_or_initialize_by(id: 6, name: "Weinzeche", shop_logo: "https://www.weinzeche.de/skin/frontend/ma_m4u/ma_m4u4/images/logo.png",
    versandkosten: 7.90, 
    versandkostenfrei_ab_betrag: 75)
    @weinzeche.save
    
    
    vintage = []
    prod_desc = []
    price = []
    prod_title =[]
    taste =[]
    category = []
    prod_mhd = []
    name = []
    product_url = []
    image_url = []
    price_per_litre_string = []
    inhalt = []
    
    #16 original 1.09
   if $demo == "ja"  
    $seiten = 1
    else
        $seiten = 16
    end
    $seiten.times do |d|
       
       
    
        url ="https://www.weinzeche.de/rotwein.html?___SID=S&limit=30&p=#{d+1}"
        page = Nokogiri::HTML(open(url))
        page.xpath('//*/div/div/div[2]/div[2]/h2/a').each do |line|  
            product_url << line['href']
        end
       
        page.css('.product-name a').each do |line|
            
        name2 =  line['title']
        name << name2
        end
        
     
       
       
       
    end
    
    product_url.each do |x|
        innerpage = Nokogiri::HTML(open(x))
                innerpage.xpath('//*[@id="product-attribute-specs-table"]/tbody/tr/td').each do |line|
                    line = line.text
                    if line.include? " ml"
                        inhalt << line
                        p line
                    end 
                end 
            
           #inhalt
        innerpage.css('#product_addtocart_form > div > div.pvdetail > div.pvdetdesk > div.pl213 > div > div > div.pl2142').each do |line|
            line = line.text
            p line
            price_per_litre_string << line
        end 
            
             innerpage.xpath('//*[@id="product_addtocart_form"]/div/div[1]/meta[3]').each do |line|
                 line = line["content"]
                 price << line
                end 
                
            innerpage.xpath('//*[@id="image"]').each do |line|
                img = line['src']
               # img.gsub!(/,.*/, '')
                image_url << img
            end
    end
    
    
    name.each do |line|
        if line.scan(/\b\d{4}\b/)
           vintage << line.scan(/\b\d{4}\b/).first
           p "vintage"
           p line.scan(/\b\d{4}\b/).first
        else
            vintage << "n/a"
        end
    end 
            
           
    
    
    
    
           
            
      #      produkt_seite.css('div.price-box span.price').each do |ta|
      #          category << 'Rotwein'
         #   end
            #Shop Logo
            
        #   produkt_seite.css('div.p-right-content div.price-box span.regular-price span.price').each do |preis|
        #    price_converted = preis.text.gsub(/[[:space:]]/, "")
        #    price3 = price_converted.sub(",",".")
        #    price << price3.sub("EUR","")
       ##     p "added price"
         #   end     
 # end
    
    
    count =  product_url.length  
        
    count.times do |i|
    
        weinzeche_wein = @weinzeche.bottles.find_or_initialize_by(name: name[i])
        weinzeche_wein.name = name[i]
        weinzeche_wein.image_url = image_url[i]
        weinzeche_wein.product_url = product_url[i]
        weinzeche_wein.price = price[i]
        weinzeche_wein.inhalt = inhalt[i]
        weinzeche_wein.vintage = vintage[i]
        weinzeche_wein.category = "Rotwein"
        weinzeche_wein.price_per_litre_string = price_per_litre_string[i]
        #hawesko_wein.prod_mhd = prod_mhd[i]
        
        weinzeche_wein.save
    
    end
    p count
end

#Mövenpick
def mövenpick_rot
    @moevenpick = Shop.find_or_initialize_by(id: 7, name: "Mövenpick", shop_logo:"http://www.moevenpick-wein.de/skin/frontend/enterprise/mpw/images/logo_de.png")
    @moevenpick.save
    
    vintage = []
    prod_desc = []
    price = []
    prod_title =[]
    taste =[]
    category = []
    prod_mhd = []
    name = []
    product_url = []
    image_url = []
    inhalt = []
    price_per_litre_string = []
  #insgesamt 25 Seiten - 02.09
    if $demo == "ja"  
    $seiten = 1
    else
        $seiten = 25
    end
    $seiten.times do |d|
       
   
        url ="http://www.moevenpick-wein.de/rotweine.html?limit=51&p=#{d+ 1}"
        page = Nokogiri::HTML(open(url))
        
     #category-view > div.category-products > ul:nth-child(3) > li.item.first > h2 > a
        page.css('h2 a').each do |line|  
            product_url << line['href']
            p line['href']
        end
        
         #price per litre
                    page.css('.base-price').each do |line|
                        line = line.text
                        p line
                    
                        price_per_litre_string << line
                    end
        
        #inhalt        
        page.css('.bottle-size').each do |line|
            line = line.text
            #line = line.gsub!("\n", "")
            #line = line.gsub!("Flasche", "")
            #line = line.gsub!("  ", "")
            
            p line
            inhalt << line
        end  
          #name     
            page.css('h2.product-name a').map{ |i| i['title'] }.each do |line| 
                name2 = line
                p name2
                name << name2
            end
            
           
                
          
        
    end
        product_url.each do |x|
            internal_link = Nokogiri::HTML(open(x))

          
            #price       
                    internal_link.xpath('//*[@id="product_addtocart_form"]/ul/li[1]/div[1]/span[1]/meta').each   do |line|
                        price2 = line['content']
                        p price2
                       price << price2
                    end
            #image url
                    internal_link.xpath('//*[@id="image"]').each do |line|
                        img =  line["src"]
                        image_url << img
                    end
           
                      
            
    end
    
    
    #vintage aus name
    name.each do |line|
        if line.scan(/\b\d{4}\b/)
            line = line.scan(/\b\d{4}\b/).first
                if !line.nil? and line != "" and line.include? "20"
                    p line
                    $check2 = 1
                    vintage << line
                else
                    vintage << "n/a"
                end 
        else
            vintage << "n/a"
        end
    end
                
                
                       
        
    count =  product_url.length  
        
    count.times do |i|
    
        wein = @moevenpick.bottles.find_or_initialize_by(product_url: product_url[i])
        wein.name = name[i]
        wein.image_url = image_url[i]
        wein.product_url = product_url[i]
        wein.price = price[i]
        wein.inhalt = inhalt[i]
        wein.vintage = vintage[i]
        wein.price_per_litre_string = price_per_litre_string[i]
        wein.category = "Rotwein"
        #hawesko_wein.prod_mhd = prod_mhd[i]
        
        wein.save
    
    end
end 

def weinclub_rot
    @weinclub = Shop.find_or_initialize_by(id: 8, name: "Weinclub", shop_logo:"Logo_Weinclub.com_.jpg")
    
    
    vintage = []
    prod_desc = []
    price2 = []
    prod_title =[]
    taste =[]
    category = []
    prod_mhd = []
    name = []
    product_url = []
    image_url = []
    links = []
    euro = []
    inhalt = []
    cents = []
    price_per_litre_string = []
  #205 Seiten
   if $demo == "ja"  
    $seiten = 1
    else
        $seiten = 205
    end
    $seiten.times do |d|
       
   
        url ="https://de.weinclub.com/rotwein/?p=#{d+ 1}#"
        page = Nokogiri::HTML(open(url))
        
        p "new cycle"
        p "###########       ROUND #{d}      ##############"
       
       
         page.xpath('//*[@id="content"]/div/div[5]/div/div[2]/h5/a').each do |line|  
            links << line['href']
        end
        
           page.xpath('//*[@id="content"]/div/div[5]/div/div[2]/small/span').each do |line|  
                        line =  line.text
                        line = line.gsub!(",",".")
                        line = line.gsub!("€","")
                        line = line.to_d
                        p line
                        if line > 0 
                            line = line.to_s
                            price_per_litre_string << line
                            p "second"
                            p line
                        end
                    end
        
 end
            
      
      
            
            
            #alle_weine > div:nth-child(2) > div > div.description > div.position-bottom > div.article.button
         links.each do |x|
        internal_link = Nokogiri::HTML(open(x))
        
        product_url << x 
 
            
                    #name
                  internal_link.xpath('//*[@id="content"]/div/div[2]/div[1]/h1').each do |line|  
                        name2 =  line['title']
                        name << name2
                    end
                                       
                  
                  
                  
                  #inhalt
                  internal_link.css('.data').each do |line|
                      line = line.text
                      if line.include? "L Flaschen"
                          inhalt << line
                      end
                  end
                  
                 
                 
            
           
                  internal_link.xpath('//*[@id="product_addtocart_form"]/div[2]/div[1]/span[1]').each   do |line|
                    eu = line
                    euro << eu.text
                   end 
            
       internal_link.xpath('//*[@id="product_addtocart_form"]/div[2]/div[1]/span[3]').each   do |line|
                   cent = line
                    cents << cent.text
        end
                   
                   
                  
                    internal_link.xpath('//*[@id="content"]/div/div[2]/div[2]/div[2]').each  do |line|
                        img =  line['style']
                        
                        img = img.gsub("background-image: url(", "")
                        img = img.sub(");","")
                        p img
                        image_url << img
                     end
                     
    end
    
             name.each do |line|
                if line.scan(/\b\d{4}\b/)
                   vintage << line.scan(/\b\d{4}\b/).first
                  # p "vintage"
                   #p line.scan(/\b\d{4}\b/).first
                else
                    vintage << "n/a"
                end
            end 
            

                
                
                
                       
           
        euro.length.times do |x|
                   p = "" 
                   eur = euro[x]
                   c = cents[x]
                   preis = "#{eur}.#{c}"
                  preis = preis.gsub(" €", "")
                   
                   price2 << preis
                   p price2
                   
        end 
       
       
       
       
       
       
        
       
        
    count =  product_url.length  
        
    count.times do |i|
    
        weinclub_wein = @weinclub.bottles.find_or_initialize_by(product_url: product_url[i])
        weinclub_wein.name = name[i]
        weinclub_wein.image_url = image_url[i]
        weinclub_wein.product_url = product_url[i]
        weinclub_wein.price = price2[i]
        weinclub_wein.inhalt = inhalt[i]
        weinclub_wein.vintage = vintage[i]
        weinclub_wein.category = "Rotwein"
        weinclub_wein.price_per_litre_string = price_per_litre_string[i]
        #hawesko_wein.prod_mhd = prod_mhd[i]
        
        weinclub_wein.save
    
    end
end 


def crawl_new_wein9
    @lidl = Shop.find_or_initialize_by(id: 9, name: "Lidl", shop_logo:"http://www.lidl.de/imgs/llogo.png")
    @lidl.save
    
    vintage = []
    prod_desc = []
    price = []
    prod_title =[]
    taste =[]
    category = []
    prod_mhd = []
    name = []
    product_url = []
    image_url = []
    links = []
    euro = []
    inhalt = []
    cents = []
    price_per_litre_string = []
    
   if $demo == "ja"  
    $seiten = 1
    else
        $seiten = 2
    end
    $seiten.times do |d|
       
   #132
        url ="http://www.lidl.de/de/rotweine/c9954?currentPage=#{d+ 1}&pageSize=132"
        page = Nokogiri::HTML(open(url))
        
        p "new cycle"
        p "###########       ROUND #{d}      ##############"
       
       links = []
     #  p links
       
         page.css('.p-b a').each do |line|  
            links << "http://www.lidl.de/de/#{line['href']}"
        end
        
        
        #inhalt
        page.css('.amount').each do |line|  
            line = line.text
            inhalt << line
        end
        
        
        
        #price_per_litre_string
       
        
       # p links
    end
            
      
      
            
            
            #alle_weine > div:nth-child(2) > div > div.description > div.position-bottom > div.article.button
         links.each do |x|
        internal_link = Nokogiri::HTML(open(x))
        
        product_url << x 
 
            
            
                  internal_link.xpath('//*[@id="articledetail"]/div/div[3]/div/h1').each do |line|  
                        name2 =  line.text.to_s
                        
                        name << name2
                    end
                  
                 
                  internal_link.xpath('//*[@id="articledetail"]/div/div[4]/div/span/small[2]').each do |line|  
                    line = line.text
                    if line.include? "1 l ="
                    price_per_litre_string << line
                    else
                    price_per_litre_string << "n/a"
                    end
                  end
            
           
                  internal_link.xpath('//*[@id="articledetail"]/div/div[4]/div/span/b/text()').each   do |line|
                   eu = line.text.gsub("\n\t\t\t\t","")
                   eu = eu.gsub(".", "").to_s
                   
                   if eu.include? "\t"
                       p "String includes 'bullshit'"
                   else 
                       euro << eu
                   end
                    
                    
                    
                    
                   end 
              print euro     
             #   n = 2
            #    euro = (n - 1).step(euro.size - 1, n).map { |i| euro[i] }
               # print euro 
            
                  internal_link.xpath('//*[@id="articledetail"]/div/div[4]/div/span/b/sup').each   do |line|
                                    
                               cent = line.text.gsub("\n\t\t\t\t","")
                              
                               cent = cent.gsub("*", "")
                               cents << cent
                               
                   end
       
                   
                   
                  
                    internal_link.xpath('//*[@id="articledetail"]/div/div[2]/div[1]/div/div/div/div/a/img').each  do |line|
                        img =  "http://www.lidl.de" + line['src']
                        
                        image_url << img
                        
                        
                    end
                    p image_url
                 
     end
     
     p "crawling complete"
                
                
                
                       
           
                    euro.length.times do |x|
                             
                              eur = euro[x]
                             # p eur
                              c = cents[x]
                             # p c
                               preis = "#{eur}.#{c}"
                              # p preis
                             # preis = preis.gsub(" €", "")
                               
                               price << preis
                              # p price2
                               
                    end 
                    
                     #vintage aus name
                        name.each do |line|
                            if line.scan(/\b\d{4}\b/)
                                line = line.scan(/\b\d{4}\b/).first
                                    if !line.nil? and line != "" and line.include? "20"
                                        p line
                                        $check2 = 1
                                        vintage << line
                                    else
                                        vintage << "n/a"
                                    end 
                            else
                                vintage << "n/a"
                            end
                        end
         
      
       
        
     count =  product_url.length  
        
    count.times do |i|
    
        wein = @lidl.bottles.find_or_initialize_by(product_url: product_url[i])
        wein.name = name[i]
        wein.image_url = image_url[i]
        wein.product_url = product_url[i]
        wein.price = price[i]
        wein.inhalt = inhalt[i]
        wein.vintage = vintage[i]
        wein.price_per_litre_string = price_per_litre_string[i]
        wein.category = "Rotwein"
        #hawesko_wein.prod_mhd = prod_mhd[i]
        
        wein.save
    
    end
end 


def vinehouse
    @vinehouse = Shop.find_or_initialize_by(id: 10, name: "Vinehouse", shop_logo:"vinehouse_logo.png")
    @vinehouse.save
    
    vintage = []
    prod_desc = []
    price = []
    prod_title =[]
    taste =[]
    category = []
    prod_mhd = []
    name = []
    product_url = []
    image_url = []
    inhalt = []
    price_per_litre_string = []
  #insgesamt 25 Seiten - 02.09
    25.times do |d|
       
   
        url ="http://www.vinehouse.de/rotwein-/?p=#{d+ 1}&n=48"
        page = Nokogiri::HTML(open(url))
        
     #category-view > div.category-products > ul:nth-child(3) > li.item.first > h2 > a
        page.xpath('/html/body/div[1]/section/div/div/div/div[2]/div[2]/div/div/div/div[2]/a[1]').each do |line|  
            product_url << line['href']
        end       
         page.xpath('/html/body/div[1]/section/div/div/div/div[2]/div[2]/div/div/div/div[2]/div[2]/div[1]/span[3]').each do |line|
                        
                        line = line.text
                          
                        if  !line.nil?
                            p line
                            line2 = line.gsub!("€\n* / 1 Liter)\n", "")
                            line2 = line.gsub!("\n(", "")
                            price_per_litre_string << line2
                        else
                            line = line.gsub!(" € * / 1 Liter)", "")
                            price_per_litre_string << line
                            
                            
                        end 
        end 
          #inhalt     /html/body/div[1]/section/div/div/div/div[2]/div[2]/div/div/div/div[2]/div[2]/div[1]/span[3]
        page.xpath('/html/body/div[1]/section/div/div/div/div[2]/div[2]/div/div/div/div[2]/div[2]/div[1]/span[2]').each do |line|
           line = line.text
                          
                        if  !line.nil?
                            
                            line2 = line.gsub!(" Liter", "")
                            p line2
                            inhalt << line2
                        else
                            inhalt << line
                            
                            
                        end 
                    end 
       
                    
    end
    
    product_url.each do |x|
        internal_link = Nokogiri::HTML(open(x))
    #price per litre            
                   
       
                
            
            
          #name     
            internal_link.xpath('/html/body/div[1]/section/div/div/div/header/div/h1').each do |line| 
                line = line.text
                line = line.gsub!("\n", "")
                name << line
            end

            #price                       
                    internal_link.xpath('/html/body/div[1]/section/div/div/div/div[1]/div[2]/div[1]/div[1]/span/meta').each do |line|
                        line = line['content']
                        
                       # p line
                        price << line
                    end
            #image url
                    internal_link.xpath('/html/body/div[1]/section/div/div/div/div[1]/div[1]/div/div/div/span/span/img').each do |line|
                        img =  line["srcset"]
                        image_url << img
                    end
            
        
    end

    
    
    #vintage aus name
    name.each do |line|
        if line.scan(/\b\d{4}\b/)
            line = line.scan(/\b\d{4}\b/).first
                if !line.nil? and line != "" and line.include? "20"
                    $check2 = 1
                    vintage << line
                else
                    vintage << "n/a"
                end 
        else
            vintage << "n/a"
        end
    end
                
    count =  name.length  
        
    count.times do |i|
    
        wein = @vinehouse.bottles.find_or_initialize_by(product_url: product_url[i])
        wein.name = name[i]
        wein.image_url = image_url[i]
        wein.product_url = product_url[i]
        wein.price = price[i]
        wein.inhalt = inhalt[i]
        wein.vintage = vintage[i]
        wein.price_per_litre_string = price_per_litre_string[i]
        wein.category = "Rotwein"
        #hawesko_wein.prod_mhd = prod_mhd[i]
        
        wein.save
    
    end
end 


def vinello
    @vinello = Shop.find_or_initialize_by(id: 10, name: "Vinehouse", shop_logo:"vinehouse_logo.png")
    @vinello.save
    
    vintage = []
    prod_desc = []
    price = []
    prod_title =[]
    taste =[]
    category = []
    prod_mhd = []
    name = []
    product_url = []
    image_url = []
    inhalt = []
    price_per_litre_string = []
  #insgesamt 43 Seiten - 09.09
    1.times do |d|
       
            
        url ="https://www.vinello.de/wein/rotweine/?p=#{d+ 1}&n=48"
        page = Nokogiri::HTML(open(url))
        
     #category-view > div.category-products > ul:nth-child(3) > li.item.first > h2 > a
        page.css('a.product--title').each do |line|  
          
            product_url << line['href']
        end       
        
          #inhalt     /html/body/div[1]/section/div/div/div/div[2]/div[2]/div/div/div/div[2]/div[2]/div[1]/span[3]
       
       
                    
    end
    
    product_url.each do |x|
        internal_link = Nokogiri::HTML(open(x))
        
         #inhalt
         $price_found = 0
         internal_link.xpath('//*[@id="cm-content"]/section/div/div[1]/div/div[1]/div[2]/div[1]/div[5]').each do |line|
           line = line.text
                          
                        if  !line.nil?
                            #line3 = line.scan(/\(([^\)]+)\)/).first
                            #line3 = line[0]
                            line2 = line.scan(/\(([^\)]+)\)/).last.first
                            line = line.gsub(line2,"")
                            line = line.gsub(" Liter","l")
                            line = line.gsub(" Flaschen","l")
                            inhalt << line
                        else
                            inhalt << "n/a"
                            
                            
                        end 
                    end 
        
        
    #price per litre            
                   
         internal_link.xpath('//*[@id="cm-content"]/section/div/div[1]/div/div[1]/div[2]/div[1]/div[5]').each do |line|
                        
                        line = line.text
                          
                        if  !line.nil?
                            line = line.scan(/\(([^\)]+)\)/).last.first
                            line = line.gsub("(", "")
                            line = line.gsub(")", "")
                            line = line.gsub("1 Liter", "")
                            line = line.gsub("1 Flaschen", "")
                            line = line.gsub("0 Liter", "")
                            line = line.gsub("0 Flaschen", "")
                            line = line.gsub("€","")
                            line = line.gsub("*","")
                            line = line.gsub(",",".")
                            line = line.gsub(" ","")
                            p line
                            price_per_litre_string << line
                        else
                            line = line.gsub!(" € * / 1 Liter)", "")
                            price_per_litre_string << line
                            
                            
                        end 
        end 
                
            
            
          #name     
            internal_link.xpath('//*[@id="cm-content"]/section/div/div[1]/div/header/div/h1').each do |line| 
                line = line.text
                line = line.gsub!("\n", "")
                name << line
            end

            #price                       
                    internal_link.xpath('//*[@id="cm-content"]/section/div/div[1]/div/div[1]/div[2]/div[1]/div[1]/span/meta').each do |line|
                        line = line['content']
                        if line.nil?
                            price << "n/a"
                        else
                        $price_found = 1
                        
                       # p line
                        price << line
                        end 
                    end
                    
                    if $price_found == 0
                        price << "n/a"
                    end
            #image url
                    internal_link.xpath('//*[@id="cm-content"]/section/div/div[1]/div/div[1]/div[1]/div[1]/div/div[1]/span').each do |line|
                        img =  line["data-img-large"]
                        image_url << img
                    end
            
        
    end

     p price.length
    
    #vintage aus name
    name.each do |line|
        if line.scan(/\b\d{4}\b/)
            line = line.scan(/\b\d{4}\b/).first
                if !line.nil? and line != "" and line.include? "20"
                    $check2 = 1
                    vintage << line
                else
                    vintage << "n/a"
                end 
        else
            vintage << "n/a"
        end
    end
                
    count =  product_url.length  
        
    count.times do |i|
    
        wein = @vinello.bottles.find_or_initialize_by(product_url: product_url[i])
        wein.name = name[i]
        wein.image_url = image_url[i]
        wein.product_url = product_url[i]
        wein.price = price[i]
        wein.inhalt = inhalt[i]
        wein.vintage = vintage[i]
        wein.price_per_litre_string = price_per_litre_string[i]
        wein.category = "Rotwein"
        #hawesko_wein.prod_mhd = prod_mhd[i]
        
        wein.save
    
    end
end 


def crawl_exe
    #rewe_rot()
    #rewe_weiss()
    delinero_rot()
    delinero_weiss()
   # vinos_rot()
    #vinos_weiss()
    hawesko_rot()
    hawesko_weiss()
    weinzeche_rot()
    mövenpick_rot()
    mövenpick_rot()
    weinclub_rot()
    crawl_new_wein9()
    vinehouse()
    
end

def leftover
    weinclub_rot()
    crawl_new_wein9()
end 
 
 
def read_xml
        @weinzeche = Shop.find_or_initialize_by(id: 6, name: "Weinzeche", shop_logo: "https://www.weinzeche.de/skin/frontend/ma_m4u/ma_m4u4/images/logo.png",
    versandkosten: 7.90, 
    versandkostenfrei_ab_betrag: 75)
    @weinzeche.save
    vintage = []
    prod_desc = []
    price = []
    prod_title =[]
    taste =[]
    category = []
    prod_mhd = []
    name = []
    product_url = []
    image_url = []
    inhalt = []
    price_per_litre_string = []
    farbe = []
    country =[]
    grape =  []
     
    doc = Nokogiri::XML(open("http://productdata-download.affili.net/affilinet_products_5171_780704.XML?auth=8xzaOSrjDtJfgt8cNIks&type=XML"))
    doc.xpath("//Deeplinks//Product").each do |line|
        line  = line.text
         product_url << line
         p line
    end 
    
    doc.xpath("//Title").each do |line|
         line  = line.text
         name << line
    end 
    
    doc.xpath("//DisplayPrice").each do |line|
         line  = line.text
         price << line
    end 
    
    doc.xpath("//Images//Img[5]//URL").each do |line|
        line = line.text
         image_url << line
     end
    doc.xpath("//BasePrice").each do |line|
        line = line.text
         price_per_litre_string << line     
    end
    doc.xpath("//Properties//Property[2]/@Text").each do |line|
         line = line.text
        if line.include? "Rot"
                line = "Rotwein"
                elsif line.include? "Weiss" or line.include? "Weiß"
                line = "Weißwein"
                elsif line.include? "Ros"
                line = "Rose"
                elsif line.include? "Schaum"
                line= "Schaumwein"
                elsif line.include? "Süss"
                line = "Süsswein"
                else
                line = "dont save"
        end    
                 category << line
        # else
         #inhalt << "n/a"
        # end 
    end
     #vintage aus name
    name.each do |line|
        if line.scan(/\b\d{4}\b/)
            line = line.scan(/\b\d{4}\b/).first
                if !line.nil? and line != "" and line.include? "20"
                    $check2 = 1
                    vintage << line
                else
                    vintage << "n/a"
                end 
        else
            vintage << "n/a"
        end
    end
                
    count =  name.length  
    count.times do |i|
        p "do it!"
        wein = @weinzeche.bottles.find_or_initialize_by(product_url: product_url[i])
        p "back back"
        wein.name = name[i]
        wein.image_url = image_url[i]
        wein.product_url = product_url[i]
        wein.price = price[i]
      # wein.inhalt = inhalt[i]
        wein.vintage = vintage[i]
        wein.category = category[i]
        wein.price_per_litre_string = price_per_litre_string[i]
        url =  product_url[i]
        #p url
        #url = url.sub("?tracid=affilinet&utm_source=Affilinet&utm_medium=Ad&utm_campaign=datafeed","")
        #url = url.sub("http://partners.webmasterplan.com/click.asp?ref=780704&site=14196&type=text&tnb=2&diurl=","")
        #url = url.sub("http","https")
        #p url
        produkt_seite = url
        begin
            produkt_seite = Nokogiri::HTML(open(produkt_seite,:allow_redirections => :all))
            p "HELLO FROM THE OTHER SIDE!!!!!!!"
            
             els =   produkt_seite.xpath("//th/b[contains(text(), 'Land')]") 
                                el  = els.first
                                if !el.nil?
                                line = el.parent.next_element.text
                                else
                                line = "n/a"
                                end
                                            p line
                                            country =  line
             els =   produkt_seite.xpath("//th/b[contains(text(), 'Rebsorte')]") 
                                el  = els.first
                                puts el
                                if !el.nil?
                                line = el.parent.next_element.text
                                else
                                line = "n/a"
                                end
                                p line
                                grape =  line  
                                
            els =   produkt_seite.xpath("//th/b[contains(text(), 'Flaschengröße')]") 
                                el  = els.first
                                puts el
                                if !el.nil?
                                line = el.parent.next_element.text
                                else
                                line = "n/a"
                                end
                                p line
                                inhalt =  line                                
        rescue Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError,Errno::ECONNREFUSED, OpenURI::HTTPError,
       Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError => e
       puts "Handle missing video here"
              ensure
              puts "not a document of any kind" 
        end
       wein.grape = grape
       wein.country = country
       wein.inhalt = inhalt
       
     
        p "hello"
      # wein.price_per_litre_string = price_per_litre_string[i]
        #hawesko_wein.prod_mhd = prod_mhd[i]
        if category[i] != "dont save"
        wein.save
        end 
        
    end
end 


def mövenpick_xml
    @moevenpick = Shop.find_or_initialize_by(id: 7, name: "Mövenpick", shop_logo:"http://www.moevenpick-wein.de/skin/frontend/enterprise/mpw/images/logo_de.png",versandkosten: 6.90 )
    @moevenpick.save
    vintage = []
    prod_desc = []
    price = []
    prod_title =[]
    taste =[]
    category = []
    prod_mhd = []
    name = []
    product_url = []
    image_url = []
    inhalt = []
    price_per_litre_string = []
    farbe = []
    country =[]
    grape =  []
     
     
    doc = Nokogiri::XML(open("http://productdata-download.affili.net/affilinet_products_4990_780704.XML?auth=8xzaOSrjDtJfgt8cNIks&type=XML"))
    doc.xpath("//Deeplinks//Product").each do |line|
        line  = line.text
         product_url << line
    end 
    
    doc.xpath("//BasePriceInformation//BasePrice").each do |line|
         line  = line.text
         price_per_litre_string << line
    end 
    
    doc.xpath("//Title").each do |line|
         line  = line.text
         name << line
    end 
    
    doc.xpath("//DisplayPrice").each do |line|
         line  = line.text
         price << line
    end 
    
    doc.xpath("//Images//Img[4]//URL").each do |line|
        line = line.text
         image_url << line
    end
    doc.xpath("//ProductCategoryPath").each do |line|
         line = line.text
            p line
            
        if line.include? "Rot"
        line = "Rotwein"
        elsif line.include? "Weiss"
        line = "Weißwein"
        elsif line.include? "Ros"
        line = "Rose"
        elsif line.include? "Schaum"
        line= "Schaumwein"
        elsif line.include? "Süss"
        line = "Süsswein"
        else
        line = "n/a"
        end    
         category << line
    end
    
    doc.xpath("//Properties//Property[15]/@Text").each do |line|
         line = line.text
            p line
         inhalt << line
    end
    doc.xpath("//Properties//Property[10]/@Text").each do |line|
         line = line.text
            p line
         country << line
    end
    doc.xpath("//Properties//Property[4]/@Text").each do |line|
         line = line.text
            p line
            line = line.gsub("100% ","")
         grape << line
    end



  
     #vintage aus name
    name.each do |line|
        if line.scan(/\b\d{4}\b/)
            line = line.scan(/\b\d{4}\b/).first
                if !line.nil? and line != "" and line.include? "20"
                    $check2 = 1
                    vintage << line
                else
                    vintage << "n/a"
                end 
        else
            vintage << "n/a"
        end
    end
                
    count =  name.length  
    count.times do |i|
        p "do it!"
        wein = @moevenpick.bottles.find_or_initialize_by(product_url: product_url[i])
        p "back back"
        wein.name = name[i]
        wein.image_url = image_url[i]
        wein.product_url = product_url[i]
        wein.price = price[i]
        wein.inhalt = inhalt[i]
        wein.vintage = vintage[i]
        wein.category = category[i]
        wein.price_per_litre_string = price_per_litre_string[i]
        wein.country = country[i]
        wein.grape = grape[i]
    
     
    
        wein.save
    end
end 

def weinversand
    def crawl(url)
     @weinversand = Shop.find_or_initialize_by(id: 9, name: "Weinversand", shop_logo:"weinversand.gif",versandkosten: 5.90, versandkostenfrei_ab_menge: 13 )
    @weinversand.save
    vintage = []
    prod_desc = []
    price = []
    prod_title =[]
    taste =[]
    category = []
    prod_mhd = []
    name = []
    product_url = []
    image_url = []
    inhalt = []
    price_per_litre_string = []
    farbe = []
    country = []
    category = []
    doc = Nokogiri::XML(open(url))
    doc.xpath("//Deeplinks//Product").each do |line|
        line  = line.text
         product_url << line
    end 
    
    doc.xpath("//BasePriceInformation//BasePrice").each do |line|
         line  = line.text
         price_per_litre_string << line
    end 
    
    doc.xpath("//Title").each do |line|
         line  = line.text
         name << line
    end 
    
    doc.xpath("//DisplayPrice").each do |line|
         line  = line.text
         price << line
    end 
    
    doc.xpath("//Images//Img[1]//URL").each do |line|
        line = line.text
         image_url << line
    end
    doc.xpath("//ProductCategoryPath").each do |line|
         line = line.text
            p line
            
        if line.include? "Rot"
        line = "Rotwein"
        elsif line.include? "Weiss" or line.include? "Weiß"
        line = "Weißwein"
        elsif line.include? "Ros"
        line = "Rose"
        elsif line.include? "Schaum"
        line= "Schaumwein"
        elsif line.include? "Süss"
        line = "Süsswein"
        else
        line
        end    
         category << line
    end
    
    doc.xpath("//Properties//Property[15]/@Text").each do |line|
         line = line.text
            p line
         inhalt << line
    end
    doc.xpath("//CategoryPath//ProductCategoryID/@Text").each do |line|
         line = line.text
            p line
         country << line
    end
    
                
    count =  name.length  
    count.times do |i|
        p "do it!"
        wein = @weinversand.bottles.find_or_initialize_by(product_url: product_url[i])
        p "back back"
        url =  product_url[i]
        produkt_seite = url
        begin
            produkt_seite = Nokogiri::HTML(open(produkt_seite,:allow_redirections => :all))
            
             els =   produkt_seite.xpath("//td/strong[contains(text(), 'Rebsorte:')]") 
                                el  = els.first
                                puts el
                                if !el.nil?
                                line = el.parent.next_element.text
                                else
                                line = "n/a"
                                end
                                p line
                                grape =  line  
            els =   produkt_seite.xpath("//td/strong[contains(text(), 'Jahrgang:')]") 
                                el  = els.first
                                puts el
                                if !el.nil?
                                line = el.parent.next_element.text
                                else
                                line = "n/a"
                                end
                                p line
                                vintage =  line  

                                
        rescue Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError,Errno::ECONNREFUSED, OpenURI::HTTPError,
       Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError => e
       puts "Handle missing video here"
              ensure
              puts "not a document of any kind" 
        end
       wein.grape = grape
        wein.name = name[i]
        wein.image_url = image_url[i]
        wein.product_url = product_url[i]
        wein.price = price[i]
        wein.inhalt = inhalt[i]
        wein.vintage = vintage
        wein.category = category[i]
        wein.price_per_litre_string = price_per_litre_string[i]
        wein.country = country[i]
     
    
        wein.save
    end
    end 

    url1 = "http://productdata-download.affili.net/affilinet_products_4215_780704.XML?auth=8xzaOSrjDtJfgt8cNIks&type=XML"
    #url2 = "http://productdata-download.affili.net/affilinet_products_5265_780704.XML?auth=8xzaOSrjDtJfgt8cNIks&type=XML"
    
    crawl(url1)
    #crawl(url2)
end




def weinvorteil
     
url = "http://productdata-download.affili.net/affilinet_products_3831_780704.XML?auth=8xzaOSrjDtJfgt8cNIks&type=XML"
    @weinvorteil = Shop.find_or_initialize_by(id: 10, name: "Weinvorteil", shop_logo:"weinvorteil.jpg",versandkosten: 4.95, versandkostenfrei_ab_betrag: 130)
    @weinvorteil.save
    vintage = []
    prod_desc = []
    price = []
    prod_title =[]
    taste =[]
    category = []
    prod_mhd = []
    name = []
    product_url = []
    image_url = []
    inhalt = []
    grape = "yeah"
    country ="ohoh"
    price_per_litre_string = []
    farbe = []
    category = []
    doc = Nokogiri::XML(open(url))
    doc.xpath("//Deeplinks//Product").each do |line|
        line  = line.text
        p line
         product_url << line
    end 
    
    doc.xpath("//BasePriceInformation//BasePrice").each do |line|
         line  = line.text
         price_per_litre_string << line
    end 
    
    doc.xpath("//Title").each do |line|
         line  = line.text
         name << line
    end 
    
    doc.xpath("//DisplayPrice").each do |line|
         line  = line.text
         price << line
    end 
    
    doc.xpath("//Images//Img[1]//URL").each do |line|
        line = line.text
         image_url << line
    end
    doc.xpath("//ProductCategoryPath").each do |line|
         line = line.text
            
        if line.include? "Rot"
        line = "Rotwein"
        elsif line.include? "Weiss" or line.include? "Weiß"
        line = "Weißwein"
        elsif line.include? "Ros"
        line = "Rose"
        elsif line.include? "Schaum"
        line= "Schaumwein"
        elsif line.include? "Süss"
        line = "Süsswein"
        else
        line = "dont save"
        end    
         category << line
    end
    
    doc.xpath("//Properties//Property[14]/@Text").each do |line|
         line = line.text
         line = line.gsub("Liter","")
         inhalt << line
    end
    


  
      doc.xpath("//Properties//Property[17]/@Text").each do |line|
         line = line.text
            p line
     if !line.nil?
         vintage << line
     else
         vintage << "n/a"
     end
 end
                
    count =  product_url.length  
    count.times do |i|
        wein = @weinvorteil.bottles.find_or_initialize_by(product_url: product_url[i])
        wein.name = name[i]
        wein.image_url = image_url[i]
        wein.product_url = product_url[i]
        url_path = product_url[i]
        p url_path
        produkt_seite = url_path.gsub("http://partners.webmasterplan.com/click.asp?ref=780704&site=12515&type=text&tnb=11&diurl=","")
            produkt_seite = Nokogiri::HTML(open(produkt_seite))
            
           # produkt_seite.xpath('//*[@id="product-attribute-specs-table"]/tbody/tr[6]/td[text()="Land"]/following-sibling::td[1]').each do |line|
                produkt_seite.xpath('//*[@id="productinfo"]/div[5]/div[3]/div[2]').each do |line|
                         line = line.text
                         country  = "n/a"
                         p country
                         if !line.nil?
                              line = line.gsub("\n","")
                                line = line.gsub("\t","")
                                line = line.gsub("\r","")
                             country = line
                             p line
                        end
                end    
            #produkt_seite.xpath('//*[@id="product-attribute-specs-table"]/tbody/tr[9]/td/text()').each do |line|
            els =   produkt_seite.search("[text()*='Rebsorte:']") 
                                el  = els.first
                                if !el.nil?
                                line = el.next_element.text
                                line = line.gsub("\n","")
                                line = line.gsub("\t","")
                                line = line.gsub("\r","")
                                else
                                line = "n/a"
                                end
                                 line = line.gsub(" (100%)","")
                                            p line
                                            grape =  line
            
            
        wein.grape = grape
        wein.country = country
        wein.price = price[i]
        wein.inhalt = inhalt[i]
        wein.vintage = vintage[i]
        wein.category = category[i]
        wein.price_per_litre_string = price_per_litre_string[i]
        if !category[i].inlcude? "Silbermedaille" and category[i] != "dont save"
          wein.save
         end
    end






end



def vinexus_xml
         
    def crawl(url)
        @vinexus = Shop.find_or_initialize_by(id: 12, name: "Vinexus", shop_logo:"vinexus.png",versandkosten: 3.95, versandkostenfrei_ab_betrag: 100)
        @vinexus.save
        vintage = []
        prod_desc = []
        price = []
        prod_title =[]
        taste =[]
        country = []
        grape = []
        category = []
        prod_mhd = []
        name = []
        product_url = []
        image_url = []
        inhalt = []
        price_per_litre_string = []
        farbe = []
        category = []
        doc = Nokogiri::XML(open(url))
        doc.xpath("//Deeplinks//Product").each do |line|
            line  = line.text
             product_url << line
        end 
        
        doc.xpath("//BasePriceInformation//BasePrice").each do |line|
             line  = line.text
             price_per_litre_string << line
        end 
        
        doc.xpath("//Details//Title").each do |line|
             line  = line.text
             name << line
        end 
        
        
        doc.xpath("//Properties//Property[4]/@Text").each do |line|
             line  = line.text
             p line
             grape << line
        end 
        
        doc.xpath("//Properties//Property[2]/@Text").each do |line|
             line  = line.text
             p line
             country << line
        end 
        
        doc.xpath("//DisplayPrice").each do |line|
             line  = line.text
             price << line
        end 
        
    
        
        doc.xpath("//Images//Img[5]//URL").each do |line|
            line = line.text
             image_url << line
        end
        
         doc.xpath("//Properties//Property[3]/@Text").each do |line|
            line = line.text
            line = line.gsub("Flaschen","")
             inhalt << line
        end
        
        
        doc.xpath("//CategoryPath//ProductCategoryPath").each do |line|
             line = line.text
                p line
                
            if line.include? "Rot"
            line = "Rotwein"
            elsif line.include? "Weiss" or line.include? "Weiß"
            line = "Weißwein"
            elsif line == "Rosé"
            line = "Rose"
            elsif line.include? "Schaum"
            line= "Schaumwein"
            elsif line.include? "Süss"
            line = "Süsswein"
            else
            line
            end    
             category << line
        end
        
        # doc.xpath("//Properties//Property[14]/@Text").each do |line|
        #      line = line.text
        #         p line
        #      inhalt << line
        # end
        
    
    
      
          doc.xpath("//Properties//Property[7]/@Text").each do |line|
             line = line.text
                p line
         if !line.nil?
             vintage << line
         else
             vintage << "n/a"
         end
     end
     
     
                    
        count =  name.length  
        count.times do |i|
            p "do it!"
            wein = @vinexus.bottles.find_or_initialize_by(product_url: product_url[i])
            p "back back"
            wein.name = name[i]
            wein.grape = grape[i]
            wein.country = country[i]
            wein.image_url = image_url[i]
            wein.product_url = product_url[i]
            wein.price = price[i]
            wein.inhalt = inhalt[i]
            wein.vintage = vintage[i]
            wein.grape = grape[i]
            wein.country = country[i]
            wein.category = category[i]
            wein.price_per_litre_string = price_per_litre_string[i]
            if wein.category != "Feinkost" and wein.category != "Wein Zubehör" and wein.category != "Weinpakete"
        
            wein.save
            end
        end
    end 
    
    url1 = "http://productdata-download.affili.net/affilinet_products_1100_780704.XML?auth=8xzaOSrjDtJfgt8cNIks&type=XML"
    
    crawl(url1)

end



def vinos_xml2
         url = "http://productdata-download.affili.net/affilinet_products_4056_780704.XML?auth=8xzaOSrjDtJfgt8cNIks&type=XML"
        
         @vinos = Shop.find_or_initialize_by(id: 13, name: "Vinos", shop_logo: "http://www.vinos.de/skin/frontend/d2c/vinos/images/logo.png",
        versandkosten: 0, 
        mindest_bestellmenge: 25, 
        verpackungsrabatt: 0.03,
        mengenrabatt: 0.03,
        mengenrabatt_menge: 18)
        @vinos.save
        vintage = []
        prod_desc = []
        price = []
        prod_title =[]
        taste =[]
        country = []
        grape = []
        category = []
        prod_mhd = []
        name = []
        product_url = []
        image_url = []
        inhalt = []
        price_per_litre_string = []
        farbe = []
        category = []
        
    
    
            doc = Nokogiri::XML(open(url))
    
            doc.xpath("//Deeplinks//Product").each do |line|
                line  = line.text
                 product_url << line
            end 
            
            doc.xpath("//BasePriceInformation//BasePrice").each do |line|
                 line  = line.text
                 price_per_litre_string << line
            end 
            
            doc.xpath("//Details//Title").each do |line|
                 line  = line.text
                 name << line
            end 
            
            doc.xpath("//DisplayPrice").each do |line|
                 line  = line.text
                 price << line
            end 
            
             doc.xpath("//Properties//Property[2]/@Text").each do |line|
                 line  = line.text
                 country << line
            end 
            
           
            
            doc.xpath("//Images//Img[4]//URL").each do |line|
                line = line.text
                 image_url << line
            end
            
            
             doc.xpath("//CategoryPath//ProductCategoryPath").each do |line|
                 line = line.text
                 #   p line
                    
                if line.include? "Rot"
                line = "Rotwein"
                elsif line.include? "Weiss" or line.include? "Weiß"
                line = "Weißwein"
                elsif line.include? "Ros"
                line = "Rose"
                elsif line.include? "Schaum"
                line= "Schaumwein"
                elsif line.include? "Süss"
                line = "Süsswein"
                else
                line = "dont save"
                end    
                 category << line
            end

###crawling the site ####
             product_url.each do |line|
                    produkt_seite = line.gsub("http://partners.webmasterplan.com/click.asp?ref=780704&site=12586&type=text&tnb=33&diurl=","")
                    produkt_seite = Nokogiri::HTML(open(produkt_seite))
                    produkt_seite.xpath('//*[@id="product-view"]/div[1]/div/div/div[3]/div[1]/div[2]/div/div/div/span[2]/text()').each do |line|
                            line = line.text
                            if line.include? "Flasche"
                                line = line.gsub("Pro Flasche","")
                                line = line.gsub("(","")
                                line = line.gsub(")","")
                                line = line.gsub("\n                                                                                                                                                                                    ","")
                                line = line.gsub("\n                                                                                    ","")
                                p line
                                inhalt << line
                            else
                                inhalt << "n/a"
                               
                            end
                    end   
                    
                    #vintage   
                    
                    vintage_found = 0
                    produkt_seite.xpath('//*[@id="product-view"]/div[1]/div/div/div[2]/h1/text()[2]').each do |line|
                            line = line.text
                            line = line.scan(/\d{4}/)
                            line = line[0]
                          
                        if line != nil
                            vintage << line
                        end
                        if line.nil?
                            line = "n/a"
                            vintage << line
                        end
                      p line
                    end 
                  
                    
             
                    
                     
                    
                 country << "Spanien" 
                            
                    # produkt_seite.xpath('//*[@id="wineinfo"]/div[1]/dl/dd[14]/a').each do |line|
                    #      line = line.text
                    #         p line
                    #      grape << line
                    # end
                    
                  
             end 
   
       
        
      
                    
        count =  name.length  
        count.times do |i|
            
            
            
            
            
            p i            
            wein = @vinos.bottles.find_or_initialize_by(product_url: product_url[i])
            wein.name = name[i]
            #wein.grape = grape[i]
            wein.country = country[i]
            wein.image_url = image_url[i]
            wein.product_url = product_url[i]
            wein.price = price[i]
            
            line = product_url[i]
            produkt_seite = line.gsub("http://partners.webmasterplan.com/click.asp?ref=780704&site=12586&type=text&tnb=33&diurl=","")
                    produkt_seite = Nokogiri::HTML(open(produkt_seite))
            
            produkt_seite.xpath('//*[@id="wineinfo"]/div[1]/dl/dd[last()]/a[1]').each do |line|
                            line = line.text
                            grape = "n/a"
                            if !line.nil?
                           # line = line.gsub(/ *\d+$/, '')
                            line = line.gsub("%", '')
                            line = line.gsub(/\ \d+/, "")
                            
                            grape = line
                            else
                            line = "n/a"
                            grape  = line
                            end
                            p line
                    end
            
            
            
            wein.grape = grape
            wein.country = country[i]
            wein.inhalt = inhalt[i]
            wein.vintage = vintage[i]
            wein.category = category[i]
            wein.price_per_litre_string = price_per_litre_string[i]
         if category[i] != "dont save"
          wein.save
         end
        end
end



def embrosia
         
         @ebrosia = Shop.find_or_initialize_by(id: 14, name: "Ebrosia", shop_logo: "https://www.ebrosia.de/media/image/5a/86/9f/logo55e58b2637216.png",
        versandkosten: 4.95)
        @ebrosia.save
        vintage = []
        prod_desc = []
        price = []
        prod_title =[]
        taste =[]
        country = []
        grape = []
        category = []
        prod_mhd = []
        name = []
        product_url = []
        image_url = []
        inhalt = []
        price_per_litre_string = []
        farbe = []
        category = []
       
       url = "http://productdata-download.affili.net/affilinet_products_172_780704.XML?auth=8xzaOSrjDtJfgt8cNIks&type=XML"

            doc = Nokogiri::XML(open(url))
            doc.xpath("//Deeplinks//Product").each do |line|
                line  = line.text
                 product_url << line
                 p line
            end 
            
            doc.xpath("//BasePriceInformation//BasePrice").each do |line|
                 line  = line.text
                 price_per_litre_string << line
            end 
            
            doc.xpath("//Details//Title").each do |line|
                 line  = line.text
                 name << line
            end 
            
            doc.xpath("//DisplayPrice").each do |line|
                 line  = line.text
                 price << line
            end 
            
            # doc.xpath("//Properties//Property[2]/@Text").each do |line|
                # line  = line.text
                # country << line
            #end 
           
            
           # doc.xpath("//Images//Img[2]//URL").each do |line|
           #     line = line.text
           #      image_url << line
           # end
            
            
             doc.xpath("//Keywords").each do |line|
                 line = line.text
                 #   p line
                    
                if line.include? "Rot"
                line = "Rotwein"
                elsif line.include? "Weiss" or line.include? "Weiß"
                line = "Weißwein"
                elsif line.include? "Ros"
                line = "Rose"
                elsif line.include? "Schaum"
                line= "Schaumwein"
                elsif line.include? "Süss"
                line = "Süsswein"
                elsif line.include? "Sekt"
                line = "Sekt"
                elsif line.include? "Champag"
                line = "Champagner"
                else
                line = "dont save"
                end    
                 category << line
             end
   
        
        
      
            #vintage aus name
    name.each do |line|
        if line.scan(/\b\d{4}\b/)
            line = line.scan(/\b\d{4}\b/).first
                if !line.nil? and line != "" and line.include? "20"
                    p line
                    $check2 = 1
                    vintage << line
                else
                    vintage << "n/a"
                end 
        else
            vintage << "n/a"
        end
    end
          
       
            
            
                
            
        
    
        

      
                    
        count =  name.length  
        count.times do |i|
            
           
            
              url_path = product_url[i]
             produkt_seite = url_path #.gsub("http://partners.webmasterplan.com/click.asp?ref=780704&site=3555&type=text&tnb=25&diurl=","")
             #produkt_seite = produkt_seite.gsub("http","https")
             begin
                        produkt_seite = Nokogiri::HTML(open(produkt_seite,:allow_redirections => :all))
                                
                               #  //*[@id="detail--product-properties"]/div/table[1]/tbody/tr[2]/td[2]     td[text()='One']/following-sibling::td[1]
                                els =   produkt_seite.search("[text()*='Herkunftsland:']") 
                                el  = els.first
                                if !el.nil?
                                line = el.next_element.text
                                line = line.gsub("\n","")
                                else
                                line = "n/a"
                                end
                                            p line
                                            country =  line
                                            
                                els =   produkt_seite.search("[text()*='Inhalt:']")
                                el  = els.first
                                if !el.nil? 
                                line = el.parent.text
                                line = line.gsub("Inhalt:","")
                                else
                                line = "n/a"
                                end
                                            p line
                                            line = line.dup
                                            while line.gsub!(/\([^()]*\)/,""); end
                                            line = line.gsub("\n","")
                                            inhalt =  line
                                            
                                            
                                 els =   produkt_seite.xpath("//*[@data-img-original]")
                                 els = els[0].attr('data-img-original')
                                            image_url =  els
                                
                                
                                els =   produkt_seite.search("[text()*='Rebsorten:']") 
                                el  = els.first
                                if !el.nil? and !el.next_element.nil?
                                line = el.next_element.text
                                
                                line = line.gsub("\n","")
                                else
                                line = "n/a"
                                end
                                            p line
                                            grape =  line
                                           
               rescue OpenURI::HTTPError => ex
              puts "Handle missing video here"
              ensure
              puts "not a document of any kind"      
              end       
            
            
            p "do it!"
            wein = @ebrosia.bottles.find_or_initialize_by(product_url: product_url[i])
            p "back back"
            wein.name = name[i]
            wein.grape = grape
            wein.country = country
            wein.image_url = image_url
            wein.product_url = product_url[i]
            wein.price = price[i]
            wein.inhalt = inhalt
            wein.vintage = vintage[i]
            wein.category = category[i]
            wein.price_per_litre_string = price_per_litre_string[i]
         if category[i] != "dont save"
            wein.save
         end
    end
end

def crawl_rest
    weinversand()
    mövenpick_xml()
    vinexus_xml()
    vinos_xml2()
    read_xml()
end
    

#end of all
end