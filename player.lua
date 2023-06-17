players={}

function init_player(i)
  i.jump_timer=0
  i.jump=false
  i.grnd=false
  i.step_interval=0
  i.max_spd.y=4
  i.anim_ctl=1
  i.lifes=5
  i.spr_heart=76
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
      i.grnd=true
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

  --shot
  if btnp(5,i.number) then
    shoot(i)
  end

  --handle screen limit
  if i.x<0 then i.x=0 end
  if i.x>120 then i.x=120 end
end

function draw_player(i)
  local sprites={}
  if i.jump then
    sprites=i.spr_jump
  elseif i.grnd and i.spd.x!=0 then --walk
    sprites=i.spr_move
  else
    sprites=i.spr_stand
  end
  if i.anim_ctl>#sprites then
    i.anim_ctl=1
  end
  draw_object_spr(i,sprites[i.anim_ctl])
  i.anim_ctl+=1

  draw_player_weapon(i)
end

function draw_players_life()
  for p in all(players) do
    spr(p.spr_stand[1],1,p.number*7+1,1,5/6)
    for i=1,p.lifes do
      spr(112,6*i+4,p.number*7+1)
    end
  end
end

function player_at(x,y,w,h)
  for i=flr(x),(x+w-1) do
    for j=flr(y),(y+h-1) do
      for p in all(players) do
        log("j="..j)
        log("i="..i)
        log(p.number.." p.x="..p.x)
        log(p.number.." p.y="..p.y)
        if i>=p.x+p.hitbox.x and i<=p.x+p.hitbox.x+p.hitbox.w 
        and j>=p.y+p.hitbox.y and i<=p.y+p.hitbox.y+p.hitbox.h then 
          return p
        end
      end
    end
  end
  return nil
end

function player_hit(p)
  p.lifes-=1

  if p.lifes==0 then
    del(players, p)
    del(objects, p)
  end
end

function get_player(number)
  return players[number+1]
end