objects={}

function init_object(obj,x,y,hitbox)
  obj.flipx=false
  obj.flipy=false
  obj.x=x
  obj.y=y
  obj.grav=0
  obj.spd={x=0,y=0}
  obj.max_spd={x=1.2,y=10}
  obj.rem={x=0,y=0}
  obj.spr=0
  obj.hits=true
  obj.active=true
  obj.hitbox=hitbox
  if hitbox==nil then
    obj.hitbox={
      x=0,
      y=0,
      w=8,
      h=8,
    }
  end
  obj.init(obj)

  add(objects,obj)
  return obj
end

function update_object(obj)
  if not obj.active then
    return
  end

  local amount
  local step
  --gravity
  obj.spd.y+=obj.grav

  --maxspeed
  obj.spd.x=clamp(obj.spd.x,-obj.max_spd.x,obj.max_spd.x)
  obj.spd.y=clamp(obj.spd.y,-obj.max_spd.y,obj.max_spd.y)

  --get move amount on x
  obj.rem.x+=obj.spd.x
  amount=flr(obj.rem.x + 0.5)
  obj.rem.x-=amount

  --move object on x
  if obj.hits then
    step=sign(amount)
    for i=0,abs(amount) do
      if not solid_at(obj.x+obj.hitbox.x+step,obj.y,obj.hitbox.w,obj.hitbox.h) then
        obj.x+=step
      else
        obj.spd.x=0
        break
      end
    end
  else
    obj.x+=amount
  end

  --get move amount on y
  obj.rem.y+=obj.spd.y
  amount=flr(obj.rem.y+0.5)
  obj.rem.y-=amount

  -- move object on y
  if obj.hits then
    step=sign(amount)
    for i=0,abs(amount) do
      if not solid_at(obj.x,obj.y+obj.hitbox.y+step,obj.hitbox.w,obj.hitbox.h) then
        obj.y+=step
      else
        obj.spd.y=0
        break
      end
    end
  else
    obj.y+=amount
  end
  --custom code
  obj.update(obj)
end

function draw_object(obj)
  if obj.draw then
    obj.draw(obj)
  else
    draw_object_spr(obj,obj.spr)
  end
end

function draw_object_spr(obj,ospr)
  spr(ospr,obj.x,obj.y,1,1,obj.flipx,obj.flipy)
end

function destroy_object(obj)
  del(objects,obj)
end