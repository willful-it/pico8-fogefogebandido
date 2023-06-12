
function collide_map(o)
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