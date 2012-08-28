#encoding: utf-8
require 'mechanize'
require 'openssl'
require 'uri'

class NicoNico
	def initialize
		@agent = Mechanize.new{|config|
			config.user_agent_alias = "Windows IE 7"
		}
	end

	def login(id,password)
		@agent.get("https://secure.nicovideo.jp/secure/login_form") # ログインページ
		form = @agent.page.form_with(:action => 'https://secure.nicovideo.jp/secure/login?site=niconico')
		form.field_with(:name => "mail").value = id # メールアドレス
		form.field_with(:name => "password").value = password # パスワード
		@agent.click('ログイン')
	end

	def getVideo(searchWord)
		videos = Array.new
		searchPage = @agent.get("http://www.nicovideo.jp/tag/" + searchWord)
		searchPage.links.find_all{|e| e.node['class'] == 'watch'}.each do |watch|
			videos << watch.href.slice(6, 17)
		end
		return videos
	end

	def getTag(videoID)
		tags = Array.new
		videoPage = @agent.get("http://www.nicovideo.jp/watch/" + videoID)
		D
		videoPage.links.find_all{|ee| ee.node['rel'] == 'tag'}.each do |tag|
			tags << tag.text
		end
		return tags
	end

	def outputTagNetwork(tags)
		0.upto(tags.size-2){|i|
			(i+1).upto(tags.size-1){|j|
				puts "#{tags[i]} #{tags[j]}"
			}
		}
	end

	def getTagsearchTotal(searchWord)
		searchPage = @agent.get("http://www.nicovideo.jp/tag/" + searchWord)
		total_string = searchPage.search("strong[@class='search_total']").inner_text
		total_string = total_string.slice(0, total_string.size-1)
		total_int = total_string.sub(",", "").to_i
		return total_int
	end

	def getVideoDate(videoID)
		tags = Array.new
		dates = Array.new
		videoPage = @agent.get("http://www.nicovideo.jp/watch/" + videoID)
		videoPage.links.find_all{|ee| ee.node['rel'] == 'tag'}.each do |tag|
			tags << tag.text
		end
		#dates_string = videoPage.search("p[@id='video_date']").inner_text
		#dates[0] = dates_string.index('<strong style="color:#393F3F;">')
		dates[0] = videoPage.search("p[@id='video_date']").at("strong").inner_text
		dates[1] = videoPage.search("p[@id='video_date']").links.inner_text	
		return tags
	end
end
