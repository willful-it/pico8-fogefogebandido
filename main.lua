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
    {1},
    {1,2,3},
    {3}
  }
  local weapon0={
    base=43,
    shooting={44,45}
  }
  local start_position0=new_vector2(20,0)
  player0=new_character(0,sprites0,weapon0,start_position0)
  add(players,player0)

  --player2
  local sprites1={
    {17},
    {17,18,19},
    {19}
  }
  local weapon1={
    base=43,
    shooting={44,45}
  }
  local start_position1=new_vector2(50,0)
  player1=new_character(1,sprites1,weapon1,start_position1)
  add(players,player1)
end

function _draw()
  cls(1)
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
      btn(k_jump, p.number),
      btn(k_shot, p.number)
    }

    update_character(p)
  end
end

