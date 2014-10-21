#Вот так вот!

require 'net/http'
require 'nokogiri'
require 'open-uri'
require 'openssl'

#параметры скрипта:
# 1 п. - адрес сайта 
# 2 п. - асолютный путь для загрузки картинок
params = Array.new(2)
if ARGV.size == params.size
	params = ARGV.each {|a|}

	content = open(params[0], ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE, 'User-Agent' => 'opera')
	doc = Nokogiri::HTML(content)
	doc_body = doc.css("img")
	
	#код для сохранения названия картинок
	arr_str = []
	for i in 0..doc_body.length - 1
		j = doc_body[i]['src'].length
		str = ""
		while j >= 0
			if doc_body[i]['src'][j] != '/'
				str += doc_body[i]['src'][j].to_s
			else	
				break
			end
			j -= 1
		end
		arr_str[i] =  "(" + i.to_s + ") "+ str.reverse
	end
	#конец

	t1 = Time.now
	#подключение к серверу, создание и запись данных в файл
	uri = URI(params[0])
	threads = []
	resp = []
	for a in 0..doc_body.length - 2
		p a.to_s + ". " + doc_body[a]['src']
		if doc_body[a]['src'] != ""
			#p 1
			threads << Thread.new(doc_body[a]['src']) do |url|
				#p 2
				http = Net::HTTP::new(uri.host, uri.port)
				resp[a] = http.get(url)
				#if resp[a].message == "OK"
					open(params[1] + arr_str[a], "wb") do |file|
			    		file.write(resp[a].body)
					end
				#else
					#p resp[a].message
					#next
				#end
				#puts "Got #{doc_body[a]['src']}: #{resp.message}"
			end
			#sleep(0.05)
			#threads[a].join
		end
	end
	threads.each { |thr| thr.join }

	t2 = Time.now
	p t2 - t1
else
	puts "Вы не ввели необходимое кол-во параметров!"
end
