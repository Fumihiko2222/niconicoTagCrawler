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

tmpnum = 0
tagList.each{|tag|
	niconico.getVideo(tag).each{|video|
		niconico.getTag(video).each{|new_tag|
			tagList << new_tag
		}
	}
	tagList.uniq!
	tmpnum.upto(tagList.size-1){|i|
		print "#{i}	"
		print "#{tagList[i]}	"
		puts niconico.getTagsearchTotal(tagList[i])
	}
	tmpnum = tagList.size
}
