function new_character(number,sprites,weapon,start_position)
  local chr={}
  chr.number=number
  chr.position=start_position
  chr.velocity=new_vector2(0,0)
  chr.acceleration=const_acceleration
  chr.flip=false
  chr.inputs={false,false,false,false,false,false}
  chr.state=stand
  chr.on_ground=false
  chr.jumping=false
  chr.target_y=0
  chr.sprites=sprites
  chr.weapon=weapon
  chr.animation_ctl=1
  chr.debug=false

  --deprecated
  chr.animation_rate=const_animation_fps
  chr.jump_finished=true
  chr.jumps_allowed=0
  chr.against_left_wall=false
  chr.against_right_wall=false
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

function update_character(chr)
  if chr.state==stand then
    handle_stand(chr)
  elseif chr.state==walk then
    handle_walk(chr)
  elseif chr.state==jump then
    handle_jump(chr)
  end

  chr.position.x=round(chr.position.x)
  chr.position.y=round(chr.position.y)
  if chr.position.y>=120 then
    chr.position.y=120
    chr.on_ground=true
  else
    chr.on_ground=false
  end
end

function handle_walk(chr)
  if not chr.on_ground then
    chr.state=jump
    return
  end

  if key_state(chr,k_left) == key_state(chr,k_right) then
    chr.state=stand
    return
  end
  if key_state(chr,k_jump) then
    start_jumping(chr)
    return
  end

  -- initial_velocity=chr.velocity.x
  -- chr.velocity.x=chr.velocity.x+chr.acceleration.x*const_time_delta
  -- chr.velocity.x=min(chr.velocity.x,const_max_velocity.x)
  -- delta_x=((chr.velocity.x+initial_velocity)/2)*const_time_delta

  initial_velocity=chr.velocity.x
  chr.velocity.x=chr.acceleration.x*const_max_velocity.x + (1-chr.acceleration.x)*const_max_velocity.x
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

  --adds jump acceleration
  --only if the button is pressed
  --and it was not unpressed somewhere
  --along the way
  real_acceleration=const_gravity
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
    chr.velocity.x=chr.velocity.x+const_acceleration_x_offground*const_time_delta
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
