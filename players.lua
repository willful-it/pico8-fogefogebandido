function create_players()
  players={}

  --the cop
  cop={}
  --position and movement
  cop.x=20
  cop.y=88
  cop.flip=false
  --sprites
  cop.spr_stand=0
  cop.spr_walk={0,1,2,3}
  --status
  cop.walking=false
  cop.lives=10
  cop.number=0
  cop.spr_walk_curr=1
  cop.spr_walk_ctrl=0
  add(players, cop)

  --the thug
  thug={}
  --position and movement
  thug.x=100
  thug.y=88
  thug.flip=true
  --sprites
  thug.spr_stand=6
  thug.spr_walk={6,7,8,9}
  --status
  thug.walking=false
  thug.lives=10
  thug.number=1
  thug.spr_walk_curr=1
  thug.spr_walk_ctrl=0
  add(players, thug)
end

function draw_players()
  foreach(players,draw_player)
end

function draw_player(p)
  if p.walking then
    spr_player(p,p.spr_walk[p.spr_walk_curr])
    if p.spr_walk_ctrl==2 then
      p.spr_walk_curr+=1
      if p.spr_walk_curr>#p.spr_walk then
        p.spr_walk_curr=1
      end
      p.spr_walk_ctrl=0
    else
      p.spr_walk_ctrl+=1
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

function handle_player_movement(p)
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
    print("left")
  end
  if (btn(1,p.number)) then --right
    if not p.flip then
      p.x+=1
    end
    p.flip=false
  end

end