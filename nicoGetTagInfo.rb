#encoding: utf-8
require 'mechanize'
require 'openssl'
require 'uri'
require 'pit'
#require 'nicoGetTag.rb'
require File.dirname(__FILE__) + "/nicoGetTag.rb"

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
	puts tag
	niconico.getVideo(tag).each{|video|
		niconico.getTag(video).each{|new_tag|
			tagList << new_tag
		}
	}
	tagList.uniq!
}
