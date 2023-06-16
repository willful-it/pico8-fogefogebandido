function new_bullet(pn,x,y,dx,sprite)
  local obj={}
  obj.x=x
  obj.y=y
  obj.dx=dx
  obj.sprite=sprite
  obj.player_number=pn
  obj.hitbox={x=3,y=5,w=3,h=1}
  return obj
end

function update_bullets(bullets)
  for b in all(bullets) do
    b.x+=b.dx*1
    if b.x<0 or b.x>128 then
      del(bullets, b)
    end
  end
end

function draw_bullets(bullets,flipx,flipy)
  log("drawing bullets="..#bullets)
  for b in all(bullets) do
    spr(b.sprite,b.x,b.y,1,1,flipx,flipy)
  end
end

