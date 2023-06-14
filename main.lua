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

function key_state(chr,k)
  --chr is a character
  --k is the key code
  local key_index=k+1
  return chr.inputs[key_index]
end

function _init()
  --physics
  const_max_velocity=new_vector2(90,90)
  const_max_velocity_x_offground=50
  const_acceleration=new_vector2(200,1500)
  const_time_delta=1/60
  const_gravity=250
  const_max_jumps=1
  const_max_jump_height=25 --pixels
  const_animation_fps=5

  --keys
  k_left=0
  k_right=1
  k_up=2
  k_down=3
  k_jump=4
  k_shot=5

  --state
  stand=1
  walk=2
  jump=3

  --character
  local sprites={
    {1},
    {1,2,3},
    {3}
  }
  local weapon={
    base=43,
    shooting={44,45}
  }
  chr=new_character(0, sprites, weapon)
end

function _draw()
  cls(1)
  print_physics(chr)
  animate_character(chr)

  local m=1
  if chr.flip then
    m=-1
  end
  spr(27,chr.position.x+(m*7),chr.position.y,1,1,chr.flip)
end

function _update60()
  chr.inputs={
    btn(k_left, 0),
    btn(k_right, 0),
    btn(k_up, 0),
    btn(k_down, 0),
    btn(k_jump, 0),
    btn(k_shot, 0)
  }

  if chr.state==stand then
    handle_stand(chr)
  elseif chr.state==walk then
    handle_walk(chr)
  elseif chr.state==jump then
    handle_jump(chr)
  end

  if chr.position.y>=120 then
    chr.position.y=120
    chr.on_ground=true
  else
    chr.on_ground=false
  end
end

function new_character(number,sprites,weapon)
  local chr={}
  chr.number=number
  chr.position=new_vector2(60,0)
  chr.velocity=new_vector2(0,0)
  chr.acceleration=const_acceleration
  chr.flip=false
  chr.inputs={false,false,false,false,false,false}
  chr.state=stand
  chr.on_ground=false
  chr.target_y=0
  chr.jump_finished=true
  chr.jumps_allowed=0
  chr.sprites=sprites
  chr.weapon=weapon
  chr.animation_ctl=1
  chr.animation_rate=const_animation_fps
  return chr
end

function animate_character(chr)
  local state_sprites=chr.sprites[chr.state]

  chr.animation_rate-=1
  if chr.animation_rate==0 then
    chr.animation_rate=const_animation_fps
    chr.animation_ctl+=1

  end
  if chr.animation_ctl>#state_sprites then
    chr.animation_ctl=1
  end
  local sprite=state_sprites[chr.animation_ctl]
  spr(sprite,chr.position.x,chr.position.y,1,1,chr.flip)
end

function handle_walk(chr)
  if key_state(chr,k_left) == key_state(chr,k_right) then
    chr.state=stand
    return
  end

  if key_state(chr,k_jump) then
    start_jumping(chr)
    return
  end

  initial_velocity=chr.velocity.x
  chr.velocity.x=chr.velocity.x+chr.acceleration.x*const_time_delta
  chr.velocity.x=min(chr.velocity.x,const_max_velocity.x)
  delta_x=((chr.velocity.x+initial_velocity)/2)*const_time_delta
  if key_state(chr,k_left) then
    chr.flip=true
    chr.position.x-=delta_x
  else
    chr.flip=false
    chr.position.x+=delta_x
  end
end

function handle_stand(chr)
  chr.velocity=vector_zero()
  if not chr.on_ground then
    chr.state=jump
  elseif key_state(chr,k_right)!=key_state(chr,k_left) then
    chr.state=walk
  elseif key_state(chr,k_jump) then
    start_jumping(chr)
  end
end

function handle_jump(chr)
  if chr.on_ground then
    chr.state=stand
    chr.jump_finished=false
    chr.jumps_allowed=const_max_jumps
    chr.velocity.y=0
    chr.target_y=0
    return
  end

  real_acceleration=const_gravity

  --adds jump acceleration
  --only if the button is pressed
  --and it was not unpressed somewhere
  --along the way
  if key_state(chr,k_jump) and not chr.jump_finished and chr.jumps_allowed>0 then
    real_acceleration-=chr.acceleration.y
  end

  --prevents double jumps
  if chr.jumps_allowed>0 and not key_state(chr,k_jump) then
    chr.jumps_allowed=0
  end

  --calculate vertical velocity
  --and vertical position
  initial_velocity=chr.velocity.y
  chr.velocity.y=chr.velocity.y+real_acceleration*const_time_delta
  chr.velocity.y=min(chr.velocity.y,const_max_velocity.y)
  if chr.velocity.y<0 then
    chr.velocity.y=max(chr.velocity.y,-const_max_velocity.y)
  end
  delta_y=((chr.velocity.y+initial_velocity)/2)*const_time_delta
  chr.position.y+=delta_y

  --checks if we have reached the
  --maximum/target jump height
  if delta_y<0 and chr.target_y>0 then
    chr.position.y=max(chr.position.y,chr.target_y)
    if chr.position.y==chr.target_y then
      chr.jump_finished=true
      chr.velocity.y=0
    end
  end

  --allow to control the horizontal
  --movement while in the air
  if key_state(chr,k_right)!=key_state(chr,k_left) then
    initial_velocity=chr.velocity.x
    chr.velocity.x=chr.velocity.x+chr.acceleration.x*const_time_delta
    chr.velocity.x=min(chr.velocity.x,const_max_velocity_x_offground)
    delta_x=((chr.velocity.x+initial_velocity)/2)*const_time_delta
    if key_state(chr,k_left) then
      chr.flip=true
      chr.position.x-=delta_x
    else
      chr.flip=false
      chr.position.x+=delta_x
    end
  end
end

function start_jumping(chr)
  chr.state=jump
  chr.jump_finished=false
  chr.jumps_allowed=const_max_jumps
  chr.on_ground=false
  chr.position.y-=1
  chr.target_y=chr.position.y-const_max_jump_height
end

function print_physics(chr)
  print("on_ground="..tostr(chr.on_ground)..",state="..tostr(chr.state),0,0)
  print_vector("x,y",chr.position,0,6)
  print_vector("vx,vy",chr.velocity,0,12)
  local inputs=""
  for i in all(chr.inputs) do
    if i then
      inputs=inputs.."t "
    else
      inputs=inputs.."f "
    end
  end
  print("inputs="..inputs,0,18)
  print("target_y="..chr.target_y,0,24)
end

function print_vector(label,vect,x,y)
  msg=label.."="..tostr(vect.x)..","..tostr(vect.y)
  print(msg,x,y)
end

function log(msg)
  printh(msg, "ffb.log")
end