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
	menuselect = menuchoice
	if btnp(4) then
		if menuselect == 2 then
			game=true
			menu=false
		end
	end
end

function updategame()
	map()
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

function drawgame()
	cls(4)
	map(0,0,0,0)
end
-->8
-- to do list

-- 1. add in menu
-- 2. add in gameplay
-- 3. highscore
__gfx__
0000000770000000bbbbbbbbbbbbbbbb000000000000000000000000444444440000000000fff000000000000000000000000000000000000000000000000000
0000077007700000bbbbbbbbbbbbbbbb000000000000000044445444595454940000000000fff000000000000000000000000000000000000000000000000000
0007700000077000bbbbbbbbb3b3bbbb000000000000000044444444494444940000000002424200000000000000000000000000000000000000000000000000
0000777007770000bbbbbbbbb333bbbb000000000000000059555495a9aaaa9a0000000002424200000000000000000000000000000000000000000000000000
0000700770070000bbbbbbbbbb3bbbbb000000000000000059222294aaaaaaaa0000000002929200000000000000000000000000000000000000000000000000
0000070000700000bbbbbbbbbbbbb3b3000000000000000059444595445555550000000002111200000000000000000000000000000000000000000000000000
0000070000700000bbbbbbbbbbbbb33300000000000000005544454455444544000000000f101f00000000000000000000000000000000000000000000000000
0000007007000000bbbbbbbbbbbbbb3b000000000000000044455455444554550000000000101000000000000000000000000000000000000000000000000000
00000070700000005556555566666666666666660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000007700000006666666666666666666665660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000007000000005555556566666666666666660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000006666666666666666656656660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000005556555566666666666666660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000006666666666666666666666560000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000005555556566666666665666660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000006666666666666666666666660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000cccccccc77cccccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000ccccccccc777cccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000cccccccccccccc77000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000cccccccccccc777c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000cccccccccccccccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000cccccccc77cccccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000ccccccccc777cccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000cccccccccccccccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0202020202020202020202020202020202020202020202020202020202020202000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0202022322232222220202020202020202000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0202021212121222230202020202020202020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0202021214131222220202020202020203000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0214141413131223220202020202020202000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0214021212121222220202020202030202000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0213022322222223220202020202020202000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0213020202020202020202020202020202000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0202020202020202020202020202020202000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3232323232320202020202020202020202000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3232323232323202020202020202020202000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3232323232323202020202020202020202000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3232323232320202020202020202020202000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0202020202020202020202020202020202000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0202020202020202020202020202020202000200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0202020202020202020202020202020202000200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000002000000020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000020000020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
