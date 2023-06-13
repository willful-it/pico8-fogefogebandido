

function collide_map(x,y,w,h)
  local collide=false
  for i=x,x+w,w do
    if (fget(mget(i/8,y/8))>0) or
         (fget(mget(i/8,(y+h)/8))>0) then
          collide=true
    end
  end

  for i=y,y+h,h do
    if (fget(mget(x/8,i/8))>0) or
         (fget(mget((x+w)/8,i/8))>0) then
          collide=true
    end
  end

  return collide
end

function collide(obj, other)
  return other.x+other.hitbox.x+other.hitbox.w > obj.x+obj.hitbox.x and
    other.y+other.hitbox.y+other.hitbox.h > obj.y+obj.hitbox.y and
    other.x+other.hitbox.x < obj.x+obj.hitbox.x+obj.hitbox.w and
    other.y+other.hitbox.y < obj.y+obj.hitbox.y+obj.hitbox.h
end