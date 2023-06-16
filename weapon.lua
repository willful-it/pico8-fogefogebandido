function init_weapon(spr_base,spr_shot)
  local w={}
  w.spr_base=spr_base
  w.spr_shot=spr_shot
  w.last_shot_time=0
  w.shots_per_second=2
  w.bullets={}
  return w
end

function draw_player_weapon(i)
  local m=1
  if i.flipx then
    m=-1
  end
  spr(i.weapon.spr_base,i.x+(m*7),i.y,1,1,i.flipx,i.flipy)
  draw_bullets(i.weapon.bullets,i.flipx,i.flipy)
end

function shoot(i)
  if t()-i.weapon.last_shot_time < 1/i.weapon.shots_per_second then
    return
  end
  local dx=1
  if i.flipx then
    dx=-1
  end
  local bullet=new_bullet(i.number,i.x+(dx*7),i.y,dx*4,i.weapon.spr_shot[1])
  add(i.weapon.bullets,bullet)
  i.weapon.last_shot_time=t()
end

gun=init_weapon(11,{12})
uzi=init_weapon(27,{28})
small_sword=init_weapon(43,{44})