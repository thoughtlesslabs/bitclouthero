pico-8 cartridge // http://www.pico-8.com
version 32
__lua__
-- bitclout the game
-- thoughtless labs

function _init()
	menu = true
	menuchoice = 1
	map_setup()
	make_player()
end

function map_setup()
	-- animation timers
	timer = 0
	anim_time = 60
	
	-- map tile settings
	wall = {18,7,6,34,35}
	water = {34}
	waves = {35}
	clout = {6}
	cloutopen = {7}
	win = {22}
	lose = {23}
end

function make_player()
	-- add player to game
	p = {}
	p.x = 1
	p.y = 1
	p.bits = 0
	p.clout = 9
	p.sprite = 9
end

function is_tile(tile_type,x,y)
	tile = mget(x,y)
	for i=1,#tile_type do
		if tile == tile_type[i] then
			return true
		end
	end
	return false
end

function can_move(x,y)
	return not is_tile(wall,x,y)
end

function swap_tile(x,y)
	tile = mget(x,y)
	mset(x,y,tile+1)
end

function unswap_tile(x,y)
	tile = mget(x,y)
	mset(x,y,tile-1)
end

-- animation functions
function toggle_tiles()
	for x=mapx,mapx+15 do
		for y=mapy,mapy+15 do
			if is_tile(cloutopen,x,y) and gameover then
				unswap_tile(x,y)
			end
			if is_tile(water,x,y) then
				swap_tile(x,y)
			elseif is_tile(waves,x,y) then
					unswap_tile(x,y)
			end
		end
	end
end

function get_clout(x,y)
	p.clout += 1
	swap_tile(x,y)
	sfx(1)
end

function display()
	disx = mapx*8
	disy = mapy*8
	
	rectfill(disx,disy,disx+128,disy+6,0)
	print("clout: "..p.clout,disx+3,disy,3)
	print(p.y,disx+80,disy,9)
end

function check_win()
	if p.clout >= 10 then
	 game = false
	 gameover = true
	end
end

function resetgame()
	map_setup()
	make_player()
	toggle_tiles()
	game=true
end

function update_map()
	if timer<0 then
		toggle_tiles()
		timer=anim_time
	end
	timer -=1
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
	move_player()
	update_map()
end

function updategameover()
	if btnp(5) then
		resetgame()
	end
end

function move_player()
	newx = p.x
	newy = p.y
	if btnp(0) then newx -= 1 end
	if btnp(1) then newx += 1 end
	if btnp(2) then newy -= 1 end
	if btnp(3) then newy += 1 end
	
	interact(newx,newy)
	
	if can_move(newx,newy) then

		p.x = mid(0,newx,127)
		p.y = mid(0,newy,63)
	else
		sfx(0)
	end
end


function interact(x,y)
	if is_tile(clout,x,y) then
		get_clout(x,y)
	elseif is_tile(win,x,y) then
		check_win()
	end
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
	cls(11)
	draw_map()
	draw_player()
		-- hud
	display()
end

function drawgameover()
	textx = mapx*8+40
	texty = mapy*8+10
	
	rectfill(textx,textx,textx+50,textx+20,0)
end

function draw_map()
 mapx = flr(p.x/16)*16
 mapy = flr(p.y/16)*16
 
 camera(mapx*8,mapy*8)
	map(0,0,0,0,128,64)
end

function draw_player()
	spr(p.sprite,p.x*8,p.y*8)
end
-->8
-- to do list

-- 1. add in menu
-- 2. add in gameplay
-- 3. highscore
__gfx__
0000000770000000bbbbbbbbbbbbbbbb000000000000000000000000a444444a0000000000fff000000000000000000000000000000000000000000000000000
0000077007700000bbbbbbbbbbbbbbbb0000000000000000444454445a5454a40000000000fff000000000000000000000000000000000000000000000000000
0007700000077000bbbbbbbbb3b3bbbb00000000000000004444444449aa4a940000000002424200000000000000000000000000000000000000000000000000
0000777007770000bbbbbbbbb333bbbb000000000000000059555495a9aaaa9a0000000002424200000000000000000000000000000000000000000000000000
0000700770070000bbbbbbbbbb3bbbbb000000000000000059222294aaaaaaaa0000000002929200000000000000000000000000000000000000000000000000
0000070000700000bbbbbbbbbbbbb3b300000000000000005944459544aaaa55000000000f111f00000000000000000000000000000000000000000000000000
0000070000700000bbbbbbbbbbbbb3330000000000000000554445445a4a45a40000000000101000000000000000000000000000000000000000000000000000
0000007007000000bbbbbbbbbbbbbb3b000000000000000044455455a44a545a0000000000101000000000000000000000000000000000000000000000000000
00000070700000005556555566666666666666660000000000dddd00000000000000000000000000000000000000000000000000000000000000000000000000
0000000770000000666666666666666666666566000000000d0000d0000000000000000000000000000000000000000000000000000000000000000000000000
000000070000000055555565666666666666666600000000d000000d000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000066666666666666666566566600000000d00dd00d000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000055565555666666666666666600000000d00dd00d000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000066666666666666666666665600000000d000000d000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000555555656666666666566666000000000d0000d0000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000006666666666666666666666660000000000dddd00000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000cccccccc77cccccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000ccccccccc777cccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000cccccccccccccc77000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000cccccccccccc777c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000cccccccccccccccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000cccccccc77cccccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000ccccccccc777cccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000cccccccccccccccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0302022222222223232322020202020202020202020202020202020202020202000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0302022322232222222223222202020202020202020202020202020202020202000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0202061212121222232223232223020202020202020202020302020202020202000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0202021214131222222222232223020203020202020302020202020202020202000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0214141413131223222222222202020202020202020303030303030202020202000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0214021212121222222223222202030202030303030203030302030202020202000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0213022322222223222222020202020202030202030303030303030202020202000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0213020202020202020202020202160202020202030203030303030302020202000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0213020202020202020202020202020202020202020303020203030202020202000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0213130202020202020202020202020302020203020202030302020202020202000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0202130302020202020303030202020302020203030202020202020202020202000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0202131313020202030202020202020202020202020303020202020202020202000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0302020213131313020202020202020202020202020202020202020202020202000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0303020202020213131313131313131313131313131313131313131313130202000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0202020202020202020202020202030303020202020202020202020202020202000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0202020202020202020202020202020202020202020202020202020202020202000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000404040404040404000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000040000040404000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000040000040400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000040000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000040000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000040000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000100001205012050120501105000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000100002b0502b0502a05029050000002705025050000002305000000210501f0501f0501e0501d0501e05026050000000000000000000000000000000000000000000000000000000000000000000000000000
