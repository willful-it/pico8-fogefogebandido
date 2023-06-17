function init_weapon(spr_base,spr_shot,bullet_hitbox)
  local w={}
  w.spr_base=spr_base
  w.spr_shot=spr_shot
  w.last_shot_time=0
  w.shots_per_second=2
  w.bullets={}
  w.bullet_hitbox=bullet_hitbox
  return w
end

function draw_player_weapon(i)
  local m=1
  if i.flipx then
    m=-1
  end
  spr(i.weapon.spr_base,i.x+(m*7),i.y,1,1,i.flipx,i.flipy)
end

function shoot(i)
  if t()-i.weapon.last_shot_time < 1/i.weapon.shots_per_second then
    return
  end
  local dx=1
  if i.flipx then
    dx=-1
  end
  new_bullet(i.number,i.x+(dx*7),i.y,i.flipx,i.weapon.spr_shot[1],i.weapon.bullet_hitbox)
  i.weapon.last_shot_time=t()
end

gun=init_weapon(11,{12},{x=3,y=4,w=2,h=1})
uzi=init_weapon(27,{28},{x=3,y=1,w=2,h=5})
small_sword=init_weapon(43,{44},{x=0,y=4,w=7,h=2})