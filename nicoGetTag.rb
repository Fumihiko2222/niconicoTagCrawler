#encoding: utf-8
require 'mechanize'
require 'openssl'
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
require 'uri'
require 'pit'

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

	def entryTag(video_number)
		page = @agent.get("http://www.nicovideo.jp/watch/" + video_number)
		links = page.links.find_all{|link| link.attributes["rel"] == "tag"}
		links.map!{|link| ["http://www.nicovideo.jp/watch/" + URI.unescape(link.href),link.text]}
	end

	def searchTag(search_name)
		page = @agent.get("http://www.nicovideo.jp/tag/" + search_name)
		page.links.find_all{|e| e.node['class'] == 'watch'}.each do |watch|
			video_tag = Array.new
			video_page = @agent.get(watch.href)
			#puts video_page.title
			video_page.links.find_all{|ee| ee.node['rel'] == 'tag'}.each do |tag|
				video_tag << tag
			end
			#puts video_tag.size
			for i in 0..(video_tag.size-2)
				for j in (i+1)..(video_tag.size-1)
					puts "#{video_tag[i]} #{video_tag[j]}"
				end
			end
		end
	end
end

#Main
#
first_tag_name_list = ["衝撃のラスト", "東方", "踊ってみた", "ゲーム"]
num_of_page = 3

niconico = NicoNico.new
niconico.login(Pit.get("niconico")[:id],Pit.get("niconico")[:pass])

first_tag_name_list.each{|first_tag_name|
	for i in 1..num_of_page
		search_name = "#{first_tag_name}?page=#{i}"
		niconico.searchTag(search_name)
	end
}

