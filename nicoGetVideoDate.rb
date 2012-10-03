#encoding: utf-8 
require 'pit'
require './NicoNico'

#Main
#
firstWord = "minecraft"
tagList = Array.new
videoList = Array.new
tagList << firstWord

niconico = NicoNico.new
niconico.login(Pit.get("niconico")[:id],Pit.get("niconico")[:pass])

tagList.each{|tag|
	niconico.getVideo(tag).each{|video|
		num = 0
		begin
			niconico.getVideoDate(video).each{|info|
				print "#{info}	"
				tagList << info if num >= 3 
				num += 1
			}
		rescue
			#puts "-------------------------ERROR------------------"
		else
		ensure
			puts ""
		end
	}
	tagList.uniq!
}
