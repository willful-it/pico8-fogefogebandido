function key_state(chr,k)
  --chr is a character
  --k is the key code
  local key_index=k+1
  return chr.inputs[key_index]
end

function _init()
  --players
  players={}

  --player1
  local sprites0={
    {6},
    {6,7,8},
    {8}
  }
  local weapon0={
    base=27,
    shooting={28}
  }
  local start_position0=new_vector2(10,0)
  player0=new_character(0,sprites0,weapon0,start_position0)
  player0.debug=true
  add(players,player0)

  --player2
  local sprites1={
    {22},
    {22,23,24},
    {24}
  }
  local weapon1={
    base=11,
    shooting={12}
  }
  local start_position1=new_vector2(105,0)
  player1=new_character(1,sprites1,weapon1,start_position1)
  player1.flip=true
  add(players,player1)
end

function _draw()
  cls()
  for p in all(players) do
    if p.debug then
      print_physics(p)
    end
    animate_character(p)
    animate_character_weapon(p)
  end
end

function _update60()
  for p in all(players) do
    p.inputs={
      btn(k_left, p.number),
      btn(k_right, p.number),
      btn(k_up, p.number),
      btn(k_down, p.number),
      btnp(k_jump, p.number),
      btn(k_shot, p.number)
    }

    -- if collide_map(p.position.x+1,p.position.y,7,7) then
    --   p.against_right_wall=true
    -- else
    --   p.against_right_wall=false
    -- end

    -- if collide_map(p.position.x-1,p.position.y,7,7) then
    --   p.against_left_wall=true
    -- else
    --   p.against_left_wall=false
    -- end

    -- if collide_map(p.position.x,p.position.y+1,7,7) then
    --   p.on_ground=true
    -- else
    --   p.on_ground=false
    -- end

    update_character(p)
  end
end

function round(f)
  local diff=(f-flr(f))*10
  if diff>5 then
    return ceil(f)
  else
    return flr(f)
  end
end