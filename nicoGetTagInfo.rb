#encoding: utf-8 
require 'pit'
require './NicoNico'

#Main
#
loopNum = 100
firstWord = "VOCALOID"
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

tagList.each{|tag|
	print "#{tag}	"
	puts niconico.getTagsearchTotal(tag)
}
