function animate_character_weapon(chr)
  local m=1
  if chr.flip then
    m=-1
  end
  spr(chr.weapon.base,chr.position.x+(m*7),chr.position.y,1,1,chr.flip)
end