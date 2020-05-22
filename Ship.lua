-- Ship
-- RJ 20200520

local Ship = {}

function createShip()
    Ship.pos = vec2(WIDTH, HEIGHT)/2
    Ship.ang = 0
end

function drawShip()
    local sx = 10
    local sy = 6
    pushStyle()
    pushMatrix()
    translate(Ship.pos.x, Ship.pos.y)
    rotate(Ship.ang)
    strokeWidth(2)
    stroke(255)
    line(sx,0, -sx,sy)
    line(-sx,sy, -sx,-sy)
    line(-sx,-sy, sx,0)
    popMatrix()
    popStyle()
end

function moveShip()
    if Button.left then Ship.ang = Ship.ang + 1 end
    if Button.right then Ship.ang = Ship.ang - 1 end
    if Button.fire then if not Ship.holdFire then fireMissile() end end
    if not Button.fire then Ship.holdFire = false end
end

function fireMissile()
    Ship.holdFire = true
    Missile(Ship)
end
