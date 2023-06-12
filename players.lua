function create_players()
  local hero=new_player(0,20,false,0,{0,1,2,3},4,5)
  add(players, hero)

  local thug=new_player(1,100,true,6,{6,7,8,9},10,11)
  add(players, thug)
end

function new_player(number,x,flip,spr_stand,spr_walk,spr_dying,spr_dead)
  local p={}
  --position and movement
  p.x=x
  p.y=20
  p.dy=gravity
  p.flip=flip
  p.hitbox={x=0,y=0,w=7,h=7}
  --sprites
  p.spr_stand=spr_stand
  p.spr_walk=spr_walk
  p.spr_dying=spr_dying
  p.spr_dead=spr_dead
  --status
  p.walking=false
  p.on_ground=false
  p.dying=false
  p.dead=false
  p.lives=10
  p.number=number
  p.spr_walk_curr=1
  p.spr_anim_ctl=0
  p.last_shot_time=0
  return p
end

function draw_players()
  foreach(players,draw_player)
end

function draw_player(p)
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

function handle_movement()
  foreach(players,handle_player_movement)
end

function handle_shooting()
  foreach(players,handle_player_shooting)
end

function handle_shot_hits()
  foreach(players,handle_player_shot_hit)
end

function handle_gravity()
  for p in all(players) do
    local prv_on_ground=p.on_ground
    if not p.on_ground then
      p.dy+=gravity
      p.y+=p.dy
      while collide_map(p) do
        p.on_ground=true
        p.y-=1
      end
    end
    if p.on_ground then
      p.dy=0
      if not prv_on_ground then
        printh("sound"..tostr(p.number),"logs.txt")
        sfx(0)
      end
    end
  end
end

function handle_player_shot_hit(p)
  if p.dead then
    --a dead player cannot be killed
    return
  end
  for b in all(bullets) do
    if collide(p,b) and
       b.player_number != p.number then
      del(bullets,b)
      if not p.dying then
        p.dying=true
        p.spr_anim_ctl=10
      end
      sfx(2)
    end
  end
end

function handle_player_shooting(p)
  if not p.on_ground or p.dying or p.dead then
    --we can't shoot while in the air
    --or dead
    return
  end

  if (btnp(4,p.number)) then
    local dx=1
    if p.flip then
      dx=-1
    end
    bullet=new_bullet(p.number,p.x+(dx*4),p.y-3,dx)
    add(bullets,bullet)
    sfx(1)
  end
end

function handle_player_movement(p)
  if p.dying and p.spr_anim_ctl > 0 then
    p.spr_anim_ctl-=1
  elseif p.dying and p.spr_anim_ctl == 0 then
    p.dying=false
    p.dead=true
  end

  if not p.on_ground or p.dying or p.dead then
    --we can't move right or left
    --if we are not in the ground
    --of if we are dead
    return
  end

  if (btn(0,p.number) or btn(1,p.number)) then
    p.walking=true
  else
    p.walking=false
  end

  if (btn(0,p.number)) then --left
    if p.flip then
      p.x-=1
    end
    p.flip=true
  end
  if (btn(1,p.number)) then --right
    if not p.flip then
      p.x+=1
    end
    p.flip=false
  end

  p.y+=1 --to simulate the colision
  p.on_ground=collide_map(p)
  if not p.on_ground then
    p.dy=gravity
  end
  p.y-=1
end
