Utils = Core.class()

function Utils:readBestScoreFromFile()
	local best_score
	local file = io.open("|D|data.txt","r")
	if not file then
		best_score = 0
	else
		best_score = file:read("*line")
		best_score = tonumber(best_score)
		file:close()
	end
	return best_score
end


function Utils:writeBestScoreToFile(best_score)

	best_score = best_score or 0
	
	local file=io.open("|D|data.txt","w+")
	file:write(best_score .. "\n")
	file:close()
end