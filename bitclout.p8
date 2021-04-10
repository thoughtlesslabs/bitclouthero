pico-8 cartridge // http://www.pico-8.com
version 32
__lua__
-- bitclout the game
-- thoughtless labs

function _init()
	menu = true
	menuchoice = 1
end

	
	
	

-->8
-- update functions

function _update60()
	if menu then
		updatemenu()
	elseif game then
		updategame()
	elseif gameover then
		updategameover()
	end
end

function updatemenu()
	menuoptions = {"choose","play","continue"}
	if btnp(0) then
		menuchoice = 2
	elseif btnp(1) then
		menuchoice = 3
	end
	return menuchoice
end
-->8
-- draw game

function _draw()
	if menu then
		drawmenu()
	elseif game then
		drawgame()
	elseif gameover then
		drawgameover()
	end
end

function drawmenu()
	cls()
	print("⬅️          ➡️")
	print(menuoptions[menuchoice],10,0)
end
-->8
-- to do list

-- 1. add in menu
-- 2. add in gameplay
-- 3. highscore
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
