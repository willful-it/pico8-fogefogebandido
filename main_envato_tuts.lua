
function _init()
  local weapon=0
  local walk_speed=c_walk_speed
  local jump_speed=c_jump_speed
  local sprites={1,2,3}

  local center=new_vector2(0, 0)
  local half_size=new_vector2(4, 4)
  local offset=new_vector2(0, half_size.y)

  mv=new_moving_objet(center,half_size,offset)
  chr1=new_character(mv,sprites,jump_speed,walk_speed,weapon)
end

function _update60()
  --printh("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@", "logs2.txt")

  chr1.inputs={
    btn(k_left, 0),
    btn(k_right, 0),
    btn(k_up, 0),
    btn(k_down, 0),
    btnp(k_jump, 0),
    btnp(k_shot, 0)
  }

  for k,v in pairs(chr1.inputs) do
    --printh(tostr(k)..tostr(v), "logs2.txt")
  end
  character_update(chr1)
end

function _draw()
  --printh(tostr(chr1.moving_object.aabb.center.x)..","..tostr(chr1.moving_object.aabb.center.y), "logs2.txt")

  cls(1)
  spr(1,
    chr1.moving_object.aabb.center.x,
    chr1.moving_object.aabb.center.y-chr1.moving_object.aabb.half_size.y,
    1,1,chr1.flip)
end



-- -----------------------------
-- constants
-- -----------------------------

--keys
k_left=0
k_right=1
k_up=2
k_down=3
k_jump=4
k_shot=5

--other constants
c_gravity=50
c_time_delta=1/60
c_max_falling_speed=500
c_min_jump_speed=100
c_jump_speed=410
c_walk_speed=25

-- -----------------------------
-- base types
-- -----------------------------
function new_vector2(x,y)
  local vector2={}
  vector2.x=x
  vector2.y=y
  return vector2
end

function vector_zero()
  return new_vector2(0,0)
end

function vector2_add(a,b)
  return new_vector2(a.x+b.x, a.y+b.y)
end

function vector2_mul_number(a,b)
  return new_vector2(a.x*b,a.y*b)
end

-- -----------------------------
-- aabb type
-- -----------------------------
function new_aabb(center,half_size)
  local aabb={}
  aabb.center=center
  aabb.half_size=half_size
  return aabb
end

function aabb_overlaps(this,other)
  if abs(this.center.x-other.center.x)>this.half_size.x+other.half_size.x then
    return false
  end
  if abs(this.center.y-other.center.y)>this.half_size.y+other.half_size.y then
    return false
  end
  return true
end

-- -----------------------------
-- moving_objet type
-- -----------------------------
function new_moving_objet(center,half_size,offset)
  --center,half_size and offset are vector2

  local mv={}
  --position
  mv.old_position=center
  mv.position=center
  --speed
  mv.old_speed=vector_zero()
  mv.speed=vector_zero()
  --scale
  mv.scale=vector_zero()
  --aabb
  mv.aabb=new_aabb(center,half_size)
  mv.aabb_offset=offset
  --position state
  mv.pushes_right_wall=false
  mv.pushed_right_wall=false
  mv.pushes_left_wall=false
  mv.pushed_left_wall=false
  mv.was_on_ground=false
  mv.on_ground=false
  mv.was_at_ceiling=false
  mv.at_ceiling=false

  return mv
end

function update_physics(mv)
  --mv is a moving_object

  --printh("> updating physics", "logs2.txt")

  --save the previous frame's data
  mv.old_position=mv.position
  mv.old_speed=mv.speed
  mv.pushed_right_wall=mv.pushed_right_wall
  mv.pushed_left_wall=mv.pushed_left_wall
  mv.was_on_ground=mv.on_ground
  mv.was_at_ceiling=mv.at_ceiling

  --update position using
  --current speed
  local s=vector2_mul_number(mv.speed,c_time_delta)
  mv.position=vector2_add(mv.position,s)

  --printh("speed x="..mv.speed.x.." y="..mv.speed.y, "logs2.txt")
  --printh("s speed x="..s.x.." y="..s.y, "logs2.txt")
  --printh("new position x="..mv.position.x.." y="..mv.position.y, "logs2.txt")
  --printh("old position x="..mv.old_position.x.." y="..mv.old_position.y, "logs2.txt")

  --if the vertical position is
  --less than zero, we assume
  --the character's on the ground
  if mv.position.y>=120 then
    mv.position.y=120
    mv.on_ground=true
  else
    mv.on_ground=false
  end

  if s.x < 0 then
    mv.position.x=flr(mv.position.x)
  else
    mv.position.x=ceil(mv.position.x)
  end

  if s.y < 0 then
    mv.position.y=flr(mv.position.y)
  else
    mv.position.y=ceil(mv.position.y)
  end

  --update AABB's center, so it
  --actually matches the new position.
  mv.aabb.center=vector2_add(mv.position, mv.aabb_offset)

  -- printh("new speed x="..mv.speed.x.." y="..mv.speed.y, "logs2.txt")
  -- printh("> end updating physics", "logs2.txt")
end

-- -----------------------------
-- character type
-- -----------------------------

function new_key_status()
  -- inputs, one per key
  local a={false,false,false,false,false,false}
  return a
end

function key_released(chr,k)
  --chr is a character
  --k is the key code
  key_index=k+1
  return not chr.inputs[key_index] and chr.prev_inputs[key_index]
end

function key_pressed(chr,k)
  --chr is a character
  --k is the key code
  key_index=k+1
  return chr.inputs[key_index] and not chr.prev_inputs[key_index]
end

function key_state(chr,k)
  --chr is a character
  --k is the key code
  local key_index=k+1
  return chr.inputs[key_index]
end

--state
s_stand=0
s_walk=1
s_jump=2
s_grab_ledge=3

function new_character(mv,sprites,jump_speed,walk_speed,weapon)
  --mv is a moving_object

  local chr={}

  chr.moving_object=mv

  chr.inputs=new_key_status()
  chr.prev_inputs=new_key_status()

  chr.current_state=s_stand
  chr.jump_speed=jump_speed
  chr.walk_speed=walk_speed

  chr.weapon=weapon
  chr.sprites=sprites
  chr.flip=false

  return chr
end

function character_update(chr)
  --chr is a character

  --printh("onground="..tostr(chr.moving_object.on_ground), "logs2.txt")
  if chr.current_state==s_stand then
    --printh("> standing", "logs2.txt")
    handle_stand(chr)
    --printh("> end standing", "logs2.txt")
  elseif chr.current_state==s_walk then
    --printh("> walking", "logs2.txt")
    handle_walk(chr)
    --printh("> end walking", "logs2.txt")
  elseif chr.current_state==s_jump then
    --printh("> jumping", "logs2.txt")
    handle_jump(chr)
    --printh("> end jumping", "logs2.txt")
  elseif chr.current_state==s_grab_ledge then
    --not implemented
  end

  --printh("final state="..chr.current_state, "logs2.txt")

  update_physics(chr.moving_object)
  if chr.current_state!=s_stand then
    printh(tostr(time())..": new position x="..mv.position.x.." y="..mv.position.y, "logs2.txt")
  end


  update_prev_inputs(chr)

end

function handle_stand(chr)

  chr.moving_object.speed=vector_zero()
  if not chr.moving_object.on_ground then
    chr.current_state=s_jump
  elseif key_state(chr,k_right)!=key_state(chr,k_left) then
    chr.current_state=s_walk
  elseif key_state(chr,k_jump) then
    chr.moving_object.speed.y=-chr.jump_speed
    chr.current_state=s_jump
  end
end

function handle_walk(chr)
  if key_state(chr,k_right)==key_state(chr,k_left) then
    chr.current_state=s_stand
    chr.moving_object.speed=vector_zero()
    return
  elseif key_state(chr,k_right) then
    chr.flip=false
    if chr.moving_object.pushes_right_wall then
      chr.moving_object.speed.x=0
    else
      chr.moving_object.speed.x=chr.walk_speed
    end
  elseif key_state(chr,k_left) then
    --printh("handling left", "logs2.txt")
    chr.flip=true
    if chr.moving_object.pushes_left_wall then
      chr.moving_object.speed.x=0
    else
      chr.moving_object.speed.x=-chr.walk_speed
    end
  end

  if key_state(chr,k_jump) then
    chr.moving_object.speed.y=chr.jump_speed
    chr.current_state=s_jump
  elseif not chr.moving_object.on_ground then
    chr.current_state=s_jump
  end
end

function handle_jump(chr)
  chr.moving_object.speed.y+=c_gravity*c_time_delta
  chr.moving_object.speed.y=min(chr.moving_object.speed.y, c_max_falling_speed)
  printh("speed y="..chr.moving_object.speed.y, "logs2.txt")

  if not key_state(chr,k_jump) and chr.moving_object.speed.y>0 then
    chr.moving_object.speed.y = min(chr.moving_object.speed.y, c_min_jump_speed)
  end

  --handle the x axis movement
  --while jumping
  if key_state(chr,k_right)==key_state(chr,k_left) then
    chr.moving_object.speed.x=0
  elseif key_state(chr,k_right) then
    chr.flip=false
    if chr.moving_object.pushes_right_wall then
      chr.moving_object.speed.x=0
    else
      chr.moving_object.speed.x=chr.walk_speed
    end
  elseif key_state(chr,k_left) then
    chr.flip=true
    if chr.moving_object.pushes_left_wall then
      chr.moving_object.speed.x=0
    else
      chr.moving_object.speed.x=-chr.walk_speed
    end
  end

  --if we hit the ground
  --printh("> jumping on ground ?"..tostr(chr.moving_object.on_ground), "logs2.txt")
  if chr.moving_object.on_ground then
    --printh("> jumping but on ground", "logs2.txt")
    --if there's no movement change state to standing
    if key_state(chr,k_right)==key_state(chr,k_left) then
      chr.current_state=s_stand
      chr.moving_object.speed=vector_zero()
    --either go right or go left are pressed so we change the state to walk
    else
      chr.current_state=s_walk
      chr.moving_object.speed.y=0
    end
  end
end

function update_prev_inputs(chr)
  for i=1,#chr.inputs do
    chr.prev_inputs[i]=chr.inputs[i]
  end
end