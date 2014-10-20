require 'open-uri'
require 'nokogiri'
 
unless ARGV.length == 2
    puts "Инструкция: {имя_скрипта, url-адрес_сайта целевая_папка}"
    puts "Error"
else
    url=ARGV[0]
    path=ARGV[1]
    data=Nokogiri::HTML(open(url))
    imgtags=data.css("img")
    arrImages=Array.new()
    file_extension=String.new
    counter=1
    imgtags.each do |tagtxt|
        val=tagtxt['src']
        filename="img_"
        unless val.nil?
            if val.rindex('.').nil?
                file_extension='.jpg'
            else
                server_ext=val[val.rindex('.'),val.length]
                if server_ext.length>4
                    file_extension='.jpg'
                else
                    file_extension=val[val.rindex('.'),val.length]
                end
            end
                while File.exists?(path+filename+counter.to_s+file_extension)
                    counter+=1
                end
             
            if val.rindex("http:").nil? && val.rindex("https:").nil?
                if val[0,2]=="//"
                    val="http:"+val
                elsif val[0,1]=="/"
                    val="http:/"+val
                else
                    val="http://"+val
                end
            end
            File.open(path+""+filename+counter.to_s+file_extension.to_s,"wb") do |f|
                f << open(val).read
            end
        end
        counter+=1
    end
end
