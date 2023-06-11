function create_players()
  players={}
  cop={}
  cop.x=20             --position
  cop.y=88
  cop.flip=false
  cop.spr_standing=0       --sprites
  cop.spr_walking={1, 2, 3, 4}  
  cop.is_walking=false --status
  cop.lives=10
  cop.number=0
  cop.spr_walking_curr=1
  cop.spr_walking_ctrl=0
  add(players, cop)
end

function draw_players()
  foreach(players, draw_player)
end

function draw_player(p)
  if p.is_walking then
    spr(p.spr_walking[p.spr_walking_curr], p.x, p.y, 1, 1, p.flip)
    if p.spr_walking_ctrl==2 then
      if p.spr_walking_curr>#p.spr_walking then
        p.spr_walking_curr=1
      else
        p.spr_walking_curr+=1
      end
      p.spr_walking_ctrl=0
    else
      p.spr_walking_ctrl+=1
    end
  else
    spr(p.spr_standing, p.x, p.y, 1, 1, p.flip)
  end
end

function handle_movement()
  foreach(players, handle_player_movement)
end

function handle_player_movement(p)
  if (btn(0,p.number) or btn(1,p.number)) then
    p.is_walking=true
  else
    p.is_walking=false
  end

  if (btn(0,p.number)) then --left
    if p.flip then
      p.x-=1
    end
    p.flip=true
    print("left")
  end
  if (btn(1, p.number)) then --right
    if not p.flip then
      p.x+=1
    end
    p.flip=false
  end
  
end