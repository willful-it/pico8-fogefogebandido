function create_players()
  local hero=new_player(0,20,false,0,{0,1,2,3},4,5,32)
  add(players, hero)

  local thug=new_player(1,100,true,6,{6,7,8,9},10,11,48)
  add(players, thug)
end

function new_player(number,x,flip,spr_stand,spr_walk,spr_dying,spr_dead,spr_bullet)
  local p={}
  --position and movement
  p.x=x
  p.y=20
  p.flip=flip
  p.dx=0
  p.dy=0
  p.max_dx=2
  p.max_dy=10
  p.hitbox={}
  update_hitbox(p)

  --sprites
  p.spr_bullet=spr_bullet
  p.spr_stand=spr_stand
  p.spr_walk=spr_walk
  p.spr_dying=spr_dying
  p.spr_dead=spr_dead
  --status
  p.walking=false
  p.on_ground=false
  p.dying=false
  p.dead=false
  p.jumps=0
  p.lives=10
  p.number=number
  p.spr_walk_curr=1
  p.spr_anim_ctl=0
  p.last_shot_time=0
  return p
end

function update_hitbox(p)
  hitbox_flipped={x=2,y=0,w=5,h=7}
  hitbox_notflipped={x=0,y=0,w=5,h=7}

  if p.flip then
    p.hitbox=hitbox_flipped
  else
    p.hitbox=hitbox_notflipped
  end
end

--DRAWING
function draw_players()
  foreach(players,draw_player)
end

function draw_player(p)
  if p.dying and p.spr_anim_ctl > 0 then
    p.spr_anim_ctl-=1
  elseif p.dying and p.spr_anim_ctl == 0 then
    p.dying=false
    p.dead=true
  end

  if p.dead then
    spr_player(p,p.spr_dead)
  elseif p.dying then
    spr_player(p,p.spr_dying)
  elseif p.walking then
    spr_player(p,p.spr_walk[p.spr_walk_curr])
    if p.spr_anim_ctl==2 then
      p.spr_walk_curr+=1
      if p.spr_walk_curr>#p.spr_walk then
        p.spr_walk_curr=1
      end
      p.spr_anim_ctl=0
    else
      p.spr_anim_ctl+=1
    end
  else
    spr_player(p,p.spr_stand)
  end
end

function spr_player(p,s)
  spr(s,p.x,p.y,1,1,p.flip)
end


--SHOT HITS
function handle_shot_hits()
  foreach(players,handle_player_shot_hit)
end

function handle_player_shot_hit(p)
  if p.dying or p.dead then
    --a dead player cannot be killed
    return
  end
  for b in all(bullets) do
    if collide(p,b) and b.player_number != p.number then
      del(bullets,b)
      if not p.dying then
        p.dying=true
        p.spr_anim_ctl=10
      end
      sfx(2)
    end
  end
end


--SHOOTING
function handle_shooting()
  foreach(players,handle_player_shooting)
end

function handle_player_shooting(p)
  if not p.on_ground or p.dying or p.dead then
    --we can't shoot while in the air
    --or dead
    return
  end
  if (btnp(k_shot,p.number)) then
    if t()-p.last_shot_time < (1/shots_per_second) then
      --allow only two shots per second
      --otherwise it would be to easy
      --to kill the opponent
      return
    end
    local dx=1
    if p.flip then
      dx=-1
    end
    bullet=new_bullet(p.number,p.x+(dx*4),p.y-3,dx,p.spr_bullet)
    add(bullets,bullet)
    p.last_shot_time=t()
    sfx(1)
  end
end

--MOVEMENT
function handle_movement()
  foreach(players,handle_player_movement)
end

function handle_player_movement(p)
  if p.dying and p.spr_anim_ctl > 0 then
    p.spr_anim_ctl-=1
  elseif p.dying and p.spr_anim_ctl == 0 then
    p.dying=false
    p.dead=true
  end

  --if not p.on_ground or p.dying or p.dead then
  if p.dying or p.dead then
    --we can't move right or left
    --if we are not in the ground
    --of if we are dead
    return
  end

  p.dy=p.dy+gravity
  p.walking=false

  if btn(k_left,p.number) and p.on_ground then
    p.dx=p.dx-0.05
    p.walking=true
    p.flip=true
  end

  if btn(k_right,p.number) and p.on_ground then
    p.dx=p.dx+0.05
    p.walking=true
    p.flip=false
  end

  if btnp(k_jump,p.number) and (p.on_ground or p.jumps<1) then
    p.on_ground=false
    p.jumps+=1
    p.dy=p.dy-1.6
  end

  update_hitbox(p)

  if collide_map(p.x+p.dx,p.y,p.hitbox.w,p.hitbox.h) then
    p.dx=0
  end

  if collide_map(p.x,p.y+p.dy,p.hitbox.w,p.hitbox.h) then
    if p.dy>0 then
      p.on_ground=true
    end
    p.dy=0
  end

  if p.on_ground then
    p.dx=p.dx*friction
    p.jumps=0
  end

  p.y=p.y+p.dy
  p.x=p.x+p.dx

  --if run off screen warp to other side
  if p.x>120 then p.x=120 end
  if p.x<0 then p.x=0 end
end
