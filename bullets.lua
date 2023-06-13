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

function update_bullets()
  for b in all(bullets) do
    b.x+=b.dx*1
  end
end

function draw_bullets()
  for b in all(bullets) do
    spr(b.sprite,b.x,b.y)
    if collide_map(b.x+b.dx,b.y,7,7) then
      sfx(3)
      del(bullets, b)
    end
  end
end

