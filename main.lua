
function _init()
  create_players()
end

function _draw()
  cls()
  draw_map()
  draw_players()
end

function _update()
  handle_movement()
end

