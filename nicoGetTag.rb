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
		videoPage.links.find_all{|ee| ee.node['rel'] == 'tag'}.each do |tag|
			tags << tag.text
		end
		outputTagNetwork(tags)
		return tags
	end

	def outputTagNetwork(tags)
		(tags.size-2).times{|i|
			(i+1).upto(tags.size-1){|j|
				puts "#{tags[i]} #{tags[j]}"
			}
		}
	end
end

#Main
#
loopNum = 10

tagList = Array.new
firstWord = "ゲーム"
tagList << firstWord

niconico = NicoNico.new
niconico.login(Pit.get("niconico")[:id],Pit.get("niconico")[:pass])

loopNum.times{|i|
	tag = tagList[i]
	niconico.getVideo(tag).each{|video|
		niconico.getTag(video).each{|new_tag|
			tagList << new_tag
		}
	}
	tagList.uniq!
}
