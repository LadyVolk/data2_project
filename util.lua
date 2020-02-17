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
return functs
