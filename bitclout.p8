pico-8 cartridge // http://www.pico-8.com
version 32
__lua__
-- bitclout the game
-- thoughtless labs

function _init()
	menu = true
	map_setup()
	make_player()
	
	gameover = false
	gamewin=false
	
	logo_y = -30
	logo_dy = 42
end

function map_setup()
	-- animation timers
	timer = 0
	anim_time = 60+rnd(10)
	
	-- map tile settings
	wall = {18,7,6,34,35}
	water = {34}
	waves = {35}
	clout = {6}
	cloutopen = {7}
	traps = {38}
	trapclosed = {39}
	win = {22}
	lose = {39}
end

function make_player()
	-- add player to game
	p = {}
	p.x = 1
	p.y = 1
	p.bits = 0
	p.clout = 0
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
	for x=0,64 do
		for y=0,31 do
			if is_tile(cloutopen,x,y) or is_tile(trapclosed,x,y) then
				if gameover then
					unswap_tile(x,y)
				end
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

function trapped(x,y)
	swap_tile(x,y)
end	

function display()
	disx = mapx*8
	disy = mapy*8
	
	rectfill(disx,disy,disx+128,disy+6,0)
	print("clout: "..p.clout,disx+3,disy,3)
end

function check_win()
	if is_tile(win,p.x,p.y) and p.clout >= 10 then
	 gamewin = true
	 gameover=true
	 sfx(3)
		game = false
	elseif is_tile(lose,p.x,p.y) then
		gamewin = false
		gameover=true
		sfx(2)
		game = false
	end
end

function resetgame()
	map_setup()
	toggle_tiles()
	make_player()
	gameover=false
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
	if not logoanimation() then
		if btnp(5) then
			menu = false
			game=true
		end
	end
	logoanimation()
end

function updategame()
	if not gameover then
		check_win()
		move_player()
		update_map()
	end
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
	elseif is_tile(traps,x,y) and gameover==false then
		trapped(x,y)
	end
end

function logoanimation()
	if logo_y != logo_dy then
		logo_y += (logo_dy - logo_y)/15
		if btnp(5) or logo_y > 41.6 then
			logo_y = 42
		end
		return true
	end
	return false
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
	spr(64,34,logo_y,8,4)
	print("❎ to start ",42,80)
end

function drawgame()
	cls(3)
	draw_map()
	draw_player()
		-- hud
	display()
end

function drawgameover()
	textx = mapx*8+15
	texty = mapy*8+50
	
	rectfill(textx,texty,textx+100,texty+20,0)
	if gamewin then
		print('congratulations',textx+20,texty+5,7)
	else
		print('sorry. you lose',textx+20,texty+5,7)
	end
	print('press ❎ to play again',textx+5,texty+12,7)
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
00000007700000003333333333333333000000000000000044445444a444444a0000000000fff000000ff000000ff00000000000000000000000000000000000
000007700770000033333333333333330000000000000000444444445a5454a40000000000fff000000ff000000ff00000000000000000000000000000000000
0007700000077000333333333b3b333300000000000000005955549549aa4a940000000002424200000240000022400000000000000000000000000000000000
0770000000000770333333333bbb3333000000000000000059222294a9aaaa9a000000000242420000224f000022400000000000000000000000000000000000
77000000000000773333333333b33333000000000000000059444595aaaaaaaa00000000029292000f029000002f900000000000000000000000000000000000
07770000000077703333333333333b3b00000000000000005544454444aaaa55000000000f111f00000110000011100000000000000000000000000000000000
07007700007700703333333333333bbb0000000000000000444554555a4a45a40000000000101000000110000110100000000000000000000000000000000000
007000777700070033333333333333b3000000000000000045545555a44a545a0000000000101000000111000100110000000000000000000000000000000000
00070000000070005556555566666666666666660000000000dddd00000000000000000000000000000000000000000000000000000000000000000000000000
000070000000700066dddd6d6666666666666566000000000d0000d0000000000000000000000000000000000000000000000000000000000000000000000000
000070000007000055555565666666666666666600000000d000000d000000000000000000000000000000000000000000000000000000000000000000000000
0000770000070000dd666666666666666566566600000000d00dd00d000000000000000000000000000000000000000000000000000000000000000000000000
007700700070770055565555666666666666666600000000d00dd00d000000000000000000000000000000000000000000000000000000000000000000000000
77000007070000776666ddd6666666666666665600000000d000000d000000000000000000000000000000000000000000000000000000000000000000000000
7700000707000777555555656666666666566666000000000d0000d0000000000000000000000000000000000000000000000000000000000000000000000000
0777000070007070ddd6666666666666666666660000000000dddd00000000000000000000000000000000000000000000000000000000000000000000000000
00707770007700708888888899888888000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00070007770007008888888889998888000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00007000000070008888888888888899000000000000000000000000000660000000000000000000000000000000000000000000000000000000000000000000
00007000000070008888888888889998000000000000000000000000000660000000000000000000000000000000000000000000000000000000000000000000
00000700000700008888888888888888000000000000000000000000000660000000000000000000000000000000000000000000000000000000000000000000
00000070007000008888888899888888000000000000000060600606060660600000000000000000000000000000000000000000000000000000000000000000
00000007007000008888888889998888000000000000000066666666066666600000000000000000000000000000000000000000000000000000000000000000
00000000770000008888888888888888000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000099999999999999990000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000999999999a9999a90000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000099999999999999990000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000999999999999a9990000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000099999999999999990000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000009999999999a999990000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000099999999999999990000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000999999999a9999a90000000000000000000000000000000000000000000000000000000000000000
00000000005000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
55555500055500000000000555500005555000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
55555550005000005500005555550005555000000000000000000000550000000000000000000000000000000000000000000000000000000000000000000000
55000550000000005500005500055000055000000000000000000000550000000000000000000000000000000000000000000000000000000000000000000000
55000550055500555555055500055000055000055550005500055055555500000000000000000000000000000000000000000000000000000000000000000000
55000550055500555555055500000000055000555555005500055055555500000000000000000000000000000000000000000000000000000000000000000000
55555500005500005500055500000000055005500005505500055000550000000000000000000000000000000000000000000000000000000000000000000000
55555550005500005500055500000000055005500005505500055000550000000000000000000000000000000000000000000000000000000000000000000000
55000550005500005500055500055000055005500005505500055000550000000000000000000000000000000000000000000000000000000000000000000000
55000550005500005500005500055000055005500005505500055000550000000000000000000000000000000000000000000000000000000000000000000000
55555550555555005555005555550005555550555555005555555000555500000000000000000000000000000000000000000000000000000000000000000000
55555500555555000555000555500005555550055550000555055000055500000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000077000770777777707777700000777700000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000077000770777777707777770007777770000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000077000770770000007700077007700770000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000077000770770000007700077077000077000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000077000770770000007700077077000077000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000077777770777777007777770077000077000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000077777770777777007777700077000077000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000077000770770000007707700077000077000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000077000770770000007700770007700770000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000077000770777777707700777007777770000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000077000770777777707700077000777700000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000006300000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__label__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000500000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000005555550005550000000000055550000555500000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000005555555000500000550000555555000555500000000000000000000055000000000000000000000000000000000000
00000000000000000000000000000000005500055000000000550000550005500005500000000000000000000055000000000000000000000000000000000000
00000000000000000000000000000000005500055005550055555505550005500005500005555000550005505555550000000000000000000000000000000000
00000000000000000000000000000000005500055005550055555505550000000005500055555500550005505555550000000000000000000000000000000000
00000000000000000000000000000000005555550000550000550005550000000005500550000550550005500055000000000000000000000000000000000000
00000000000000000000000000000000005555555000550000550005550000000005500550000550550005500055000000000000000000000000000000000000
00000000000000000000000000000000005500055000550000550005550005500005500550000550550005500055000000000000000000000000000000000000
00000000000000000000000000000000005500055000550000550000550005500005500550000550550005500055000000000000000000000000000000000000
00000000000000000000000000000000005555555055555500555500555555000555555055555500555555500055550000000000000000000000000000000000
00000000000000000000000000000000005555550055555500055500055550000555555005555000055505500005550000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000007700077077777770777770000077770000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000007700077077777770777777000777777000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000007700077077000000770007700770077000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000007700077077000000770007707700007700000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000007700077077000000770007707700007700000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000007777777077777700777777007700007700000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000007777777077777700777770007700007700000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000007700077077000000770770007700007700000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000007700077077000000770077000770077000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000007700077077777770770077700777777000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000007700077077777770770007700077770000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000006666600000066600660000006606660666066606660000000000000000000000000000000000000000000
00000000000000000000000000000000000000000066060660000006006060000060000600606060600600000000000000000000000000000000000000000000
00000000000000000000000000000000000000000066606660000006006060000066600600666066000600000000000000000000000000000000000000000000
00000000000000000000000000000000000000000066060660000006006060000000600600606060600600000000000000000000000000000000000000000000
00000000000000000000000000000000000000000006666600000006006600000066000600606060600600000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000

__map__
0302022222222223232322020202020206020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0302022322232222222223222202020202020202020202020202020202020602020202020202020202020202020202020202020202020202020202020202020202020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0202021212121222232223232223020202020202020202020302020202020202020202020202020202020202020202020202020202020202020202020202020202020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0202021214061222222222232223020203020226020302020202020202020202022602020202020203030303030202020202020202020202020202020202020202020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0214141413131223222222222202020202020202020303030303030202020202020202020202020203030303030303030302020202020202020202020202020202020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0214261212121222222223222202030202030303030203030302030202020202020202020202020202030303030303030303020202260202020602020202020202020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0213022322222223222222020302020202030202030303030303030202020202020202131313131313131313131313130202020202020202020202020202020202020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0213020202020202020202020202160202020202030203030303030302020202020202130202020202020202020202131313020202020202020202020202131313020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0213020202020202020202020202020202020202020303020203030202020202020213020202020202020202020202020213131313131313131313131313130202020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0213130202020202020202020202020302020203020202030302020202020202131302020202020202020202020202020202021302020202020202020202020202020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0202130302020202020303030202020302020203030202020202020202020202130202020202020202030206020202020202021302020202020202020202020202020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0202131313020202030202020202020202020202020303020202260202020213130202020202020202030202020202020202131302020202020202020202020202020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0302020213131313020202020202020202020202020202020202020202021313020202020202020202030302020202020202130202020202020202020202020202020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0303020202020213131313131313131313131313131313131313131313131302020302020202030303020303020202020202130202020202020303020302020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0202020202020213020202020206030303020202021302020202020202020202020303020203030303020202030202020213130203030302020303030302020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0202020202020213020202020202020202020202021313020202020202020202020203030302030303030303030202020213020202020302020303030202020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0202020226020213020202020202020202020202020213020202260202020202020202020202020303030202020202021313020202020302030203030202020602020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0202020202020213131313020202020202020202020213020202020202020202020202020202020202030302020202131302020202020303030303030202020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0202030303030213020213130202020202020202020213130202020202020202020202020202020202020202021313130202020202020203030203030302020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0203030303030313130202130202020202020202020202130202020202020202020202020202020226020202131302020202020202020202030202030303020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0202020303030303130202130202020202020303030202131302020202020202020202020202020202020202130202020202020202020202030203030202020202020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0202020203030303131313130202020203030202020202021302020202020202020202020202020202020213130202020202020202020202030303020202020202020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0202020202020303020202020202030303030303030203031302030303030303030303020202020202020213020202020202020202260202020202020202020202020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0202020206020203020202020203030303030303020303021303030202060203020202030302020202021313020202020202020202020202020202020202020202020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0202020202020202020202020302020302030303030202021303030202020203030302020202020202021302020206020202020202021313131313131313020202020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0202020202020202020202020303030303030302020202021313030303030303030303020202020202021302020202020202020202131302020202020202131313020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0202020202020202020202020202020303030302020202020213030303030303030303020202020202131302020202020202020202130202020202020202020202131313000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0202020202020202022602020202020202020202363636363613030303020303030303020202020202131302020202020202020202130202020202020202020202020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0202020202020202020202020202020202020202373737373613131302030303030302020202020202021302020202020202020213130202020202020202020202020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0202020202020202020202020202020202020202373636363636361313131313131313020202020202021302020213131313131313020202020202260202020202020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0202020202020202020202020202020202020202363637363736370202020202020213131313131313131313131313020202020202020202020202020202020202020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0202020202020202020202020202020202020202363636363636360202020202020202020202020202020202020202020202020202020202020202020202020202020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000100001205012050120501105000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000100002b0502b0502a05029050000002705025050000002305000000210501f0501f0501e0501d0501e05026050000000000000000000000000000000000000000000000000000000000000000000000000000
000400002c05029050280502605023050210501e0501a05018050150501505011050100500d0500a0500a050080500605004050030500205001050000500d0000000000000000000000000000000000000000000
0001000009050090500a0500a0500a0500b0500c0500d0500e0501005011050130501405016050180501a0501d0502105025050280502b05031050360503c0503f0001d000200002300026000260002800028000
