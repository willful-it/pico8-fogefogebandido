function create_players()
  local start_y=20
  gravity=0.2

  players={}

  --the cop
  cop={}
  --position and movement
  cop.x=20
  cop.y=start_y
  cop.dy=gravity
  cop.flip=false
  --sprites
  cop.spr_stand=0
  cop.spr_walk={0,1,2,3}
  --status
  cop.walking=false
  cop.on_ground=false
  cop.lives=10
  cop.number=0
  cop.spr_walk_curr=1
  cop.spr_walk_ctl=0
  add(players, cop)

  --the thug
  thug={}
  --position and movement
  thug.x=100
  thug.y=start_y
  thug.dy=gravity
  thug.flip=true
  --sprites
  thug.spr_stand=6
  thug.spr_walk={6,7,8,9}
  --status
  thug.walking=false
  thug.on_ground=false
  thug.lives=10
  thug.number=1
  thug.spr_walk_curr=1
  thug.spr_walk_ctl=0
  add(players, thug)
end

function draw_players()
  foreach(players,draw_player)
end

function draw_player(p)
  if p.walking then
    spr_player(p,p.spr_walk[p.spr_walk_curr])
    if p.spr_walk_ctl==2 then
      p.spr_walk_curr+=1
      if p.spr_walk_curr>#p.spr_walk then
        p.spr_walk_curr=1
      end
      p.spr_walk_ctl=0
    else
      p.spr_walk_ctl+=1
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

function handle_gravity()
  for p in all(players) do
    local prv_on_ground=p.on_ground
    if not p.on_ground then
      p.dy+=gravity
      p.y+=p.dy
      while cmap(p) do
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

function cmap(o)
  local x1=o.x/8
  local y1=o.y/8
  local x2=(o.x+7)/8
  local y2=(o.y+7)/8
  local a=fget(mget(x1,y1),flg_ground)
  local b=fget(mget(x1,y2),flg_ground)
  local c=fget(mget(x2,y2),flg_ground)
  local d=fget(mget(x2,y1),flg_ground)
  return a or b or c or d
end

function handle_player_movement(p)
  if not p.on_ground then
    --we can't move right or left
    --if we are not in the ground
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
  p.on_ground=cmap(p)
  if not p.on_ground then
    p.dy=gravity
  end
  p.y-=1
end