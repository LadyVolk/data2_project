local functs = {}

function functs.collision(e1, e2)
  if e1.pos.x > e2.pos.x+e2.size.x or e1.pos.x+e1.size.x < e2.pos.x or
     e1.pos.y > e2.pos.y+e2.size.y or e1.pos.y+e1.size.y < e2.pos.y
  then
    return false
  else
    return true
  end
end

--create element that can be passed through channels
function functs.create_soft(element)
  local soft ={
    id = element.id,
  }
  return soft
end
return functs
