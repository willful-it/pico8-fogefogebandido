fwall=1
bullets={}

function new_bullet(x,y,dx)
    local obj={}

    obj.x=x
    obj.y=y
    obj.dx=dx
    obj.sprite=32
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

-- detect if hitbox of object ‘o’ does hit the a wall map sprite
function collide_wall(o)
  --detect each corner of the hitbox one by one if it collide
  --the <skin> allow to not detect floor on the side if we are
  --standing on the ground
  --top left corner
  --position of the top left corner of the hitbox is calculated
  --by adding the X position of the object and his hitbox this
  --number is divided by 8, because ‘mget’ use sprite position and
  --not pixel position, and all sprite in PICO-8 are 8 pixels wide
  --flr() allow to get a integer without decimal
  local xpos = flr((o.x + o.hitbox.x)/8)
  local ypos = flr((o.y + o.hitbox.y)/8)
  --get the sprite at the calculated position
  local foundsprite = mget(xpos, ypos)
  --stock in ‘d’ variable is the found sprite is a wall or not
  local d = fget(foundsprite , fwall)
  -- top right corner
  if d == false then
    d = fget(mget(flr((o.x + o.hitbox.x +
    o.hitbox.w)/8),flr((o.y + o.hitbox.y)/8)),fwall)
  end
  --bottom left corner
  if d == false then
    d = fget(mget(flr((o.x + o.hitbox.x)/8),flr((o.y + o.hitbox.y +o.hitbox.h)/8)),fwall)
  end
  --bottom right corner
  if d == false then
    d = fget(mget(flr((o.x + o.hitbox.x + o.hitbox.w)/8),flr((o.y + o.hitbox.y + o.hitbox.h)/8)),fwall)
  end

  return d
end

--DETECT if 2 objects with hitbox are colliding
function collide(obj, other)
  return other.x+other.hitbox.x+other.hitbox.w > obj.x+obj.hitbox.x and
    other.y+other.hitbox.y+other.hitbox.h > obj.y+obj.hitbox.y and
    other.x+other.hitbox.x < obj.x+obj.hitbox.x+obj.hitbox.w and
    other.y+other.hitbox.y < obj.y+obj.hitbox.y+obj.hitbox.h
end