function init_bullet(b)
end

function update_bullet(b)
  b.x+=b.spd.x
  if b.x<0 or b.x>128 or b.spd.x==0 then
    del(objects,b)
  end

  --log("b.x="..b.x)
  --log("b.y="..b.y)
  p=player_at(b.x,b.y,b.hitbox.w,b.hitbox.h)
  if p != nil and p.number !=b.player_number then
    local shooting_player=get_player(b.player_number)
    make_blood_ps(p.x,rnd(10)+p.y,shooting_player.flipx)
    player_hit(p)
    del(objects,b)
  end
end

function draw_bullet(b)
  spr(b.sprite,b.x,b.y,1,1,b.flipx,false)
end

function new_bullet(pn,x,y,flipx,sprite,hitbox)
  obj={}
  obj.sprite=sprite
  obj.player_number=pn
  obj.draw=draw_bullet
  obj.update=update_bullet
  obj.init=init_bullet
  init_object(obj,x,y,hitbox)
  obj.flipx=flipx

  if flipx then
    obj.spd.x=-4
  else
    obj.spd.x=4
  end
  return obj 
end
