clouds = {}

function init_clouds()
  for i=0,16 do
    add(clouds,{
      x=rnd(128),
      y=rnd(80),
      spd=1+rnd(4),
      w=32+rnd(64)
    })
  end
end

function draw_clouds()
  -- clouds
  foreach(clouds, function(c)
    c.x+=c.spd
    rectfill(c.x,c.y,c.x+c.w,c.y+(1-c.w/96)*12,7)
    if c.x - 32 > 128 then
        c.x = -c.w
        c.y=rnd(128-8)
    end
  end)
end