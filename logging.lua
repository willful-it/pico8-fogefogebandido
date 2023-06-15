function print_physics(chr)
  print("on_ground="..tostr(chr.on_ground)..",state="..tostr(chr.state),0,0)
  print_vector("x,y",chr.position,0,6)
  print_vector("vx,vy",chr.velocity,0,12)
  local inputs=""
  for i in all(chr.inputs) do
    if i then
      inputs=inputs.."t "
    else
      inputs=inputs.."f "
    end
  end
  print("inputs="..inputs,0,18)
  print("target_y="..chr.target_y,0,24)
end

function print_vector(label,vect,x,y)
  msg=label.."="..tostr(vect.x)..","..tostr(vect.y)
  print(msg,x,y)
end

function log(msg)
  printh(msg, "ffb.log")
end