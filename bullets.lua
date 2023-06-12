function new_bullet(pn,x,y,dx)
    local obj={}
    obj.x=x
    obj.y=y
    obj.dx=dx
    obj.sprite=32
    obj.player_number=pn
    obj.update=function(this)
        this.x+=this.dx*2
    end
    obj.hitbox={x=2,y=4,w=4,h=3}
    return obj
end

function update_bullets()
  for b in all(bullets) do
    b.update(b)
  end
end

function draw_bullets()
  for b in all(bullets) do
    spr(b.sprite,b.x,b.y)
  end
end

