
function _init()
  config_map()
  create_players()
end

function _draw()
  cls()
  draw_map()
  draw_players()
end

function _update()
  handle_gravity()
  handle_movement()
end

