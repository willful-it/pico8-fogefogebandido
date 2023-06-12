
function _init()
  config_map()
  create_players()
end

function _draw()
  cls()
  draw_map()
  draw_players()
  draw_bullets()
end

function _update()
  handle_shot_hits()
  handle_shooting()
  handle_gravity()
  handle_movement()
  update_bullets()
end

