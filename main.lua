function _init()
  load_room(0,0)
  player0={
    tile=1,
    number=0,
    draw=draw_player,
    update=update_player,
    init=init_player,
    spr_move={1,2,3},
    spr_jump={3},
    spr_stand={1},
    weapon=uzi
  }
  init_object(player0,0,0)

  player1={
    tile=1,
    number=1,
    draw=draw_player,
    update=update_player,
    init=init_player,
    spr_move={22,23,24},
    spr_jump={24},
    spr_stand={22},
    weapon=gun
  }
  init_object(player1,100,0)

  add(players,player0)
  add(players,player1)

  make_starfield_ps()
end

function _update()
  foreach(objects,update_object)
  update_psystems()
end

function _draw()
  -- clear the screen
  cls(0)
	for ps in all(particle_systems) do
		draw_ps(ps)
	end  
  map(room.x,room.y,0,0)
  foreach(objects,draw_object)
  draw_players_life()
end