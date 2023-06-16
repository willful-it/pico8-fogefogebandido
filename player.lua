
function init_player(i)
  i.jump_timer=0
  i.jump=false
  i.grnd=false
  i.step_interval=0
  i.max_spd.y=4
  i.anim_ctl=1
end

function update_player(i)
  --player move left/right
  if btn(1,i.number) then
    i.flipx=false
    i.spd.x+=accel
  elseif btn(0,i.number) then
    i.flipx=true
    i.spd.x-=accel
  else
    i.spd.x=appr(i.spd.x,0,fric)
  end

  if solid_at(i.x,i.y+1,8,8) then
    if not i.grnd then
      i.grnd=true;
    end
    i.grnd=true
  else
    i.grnd=false
  end

  -- player jump
  if btn(4,i.number) and not i.jump and i.grnd then
    i.jump_timer=limit_jump_timer
  end
  if btn(4,i.number) and i.jump_timer>0 then
    i.spd.y=-2
  end
  i.jump_timer-=1

  -- slow grav in middle of jump
  if btn(4,i.number) and abs(i.spd.y)<0.5 then
    i.grav=gravity_jump
  else
    i.grav=gravity
  end

  i.jump=btn(4,i.number)
end

function draw_player(i)
  local sprites=i.spr_stand
  if i.jump then
    log("draw jumping")
    sprites=i.spr_jump
  elseif i.grnd and i.spd.x!=0 then --walk
    log("draw move")
    sprites=i.spr_move
  else
    log("draw stand")
  end
  if i.anim_ctl>#sprites then
    i.anim_ctl=1
  end
  draw_object_spr(i,sprites[i.anim_ctl])
  i.anim_ctl+=1
end