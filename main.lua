
function _init()
  create_players()
end

function _draw()
  cls()
  draw_map()
  draw_players()
  draw_bullets()
end

function _update60()
  handle_shot_hits()
  handle_shooting()
  update_bullets()
  handle_movement()
end

