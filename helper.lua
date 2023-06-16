function solid_at(x,y,w,h)
  for i=flr(x/8),(x+w-1)/8 do
    for j=flr(y/8),(y+h-1)/8 do
      if solid_tile(i,j) then
        return true
      end
    end
  end
  return false
end

function solid_tile(x,y)
  if x<0 or y<0 or x>=16 or y>=16 then
    return false
  end
  return fget(mget(room.x*16+x, room.y*16+y),0)
end

function clamp(val,a,b)
  return max(a, min(b, val))
end

function appr(val,target,amount)
  if val > target then
    return max(val-amount,target)
  else
    return min(val+amount,target)
  end
end

function sign(v)
  if v>0 then
    return 1
  elseif v<0 then
    return -1
  else return 0 end
end

function log(msg)
  printh(msg, "ffb.log")
end