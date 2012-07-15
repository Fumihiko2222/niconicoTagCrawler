#encoding: utf-8
require 'pit'
require './NicoNico'

#Main
#
loopNum = 10

firstWord = "ゲーム"
tagList = Array.new
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
