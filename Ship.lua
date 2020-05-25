-- Ship
-- RJ 20200520

local Ship = {}

local rotationStep = math.rad(1) -- one degree in radians

function createShip()
    Ship.pos = vec2(WIDTH, HEIGHT)/2
    Ship.radians = 0
    Ship.step = vec2(0,0)
end

function drawShip()
    local sx = 10
    local sy = 6
    pushStyle()
    pushMatrix()
    translate(Ship.pos.x, Ship.pos.y)
    rotate(math.deg(Ship.radians))
    strokeWidth(2)
    stroke(255)
    line(sx,0, -sx,sy)
    line(-sx,sy, -sx,-sy)
    line(-sx,-sy, sx,0)
    popMatrix()
    popStyle()
end

function moveShip()
    if Button.left then Ship.radians = Ship.radians + rotationStep end
    if Button.right then Ship.radians = Ship.radians - rotationStep end
    if Button.fire then if not Ship.holdFire then fireMissile() end end
    if not Button.fire then Ship.holdFire = false end
    actualShipMove()
end

function actualShipMove()
    if Button.go then
        local accel = vec2(0.015,0):rotate(Ship.radians)
        Ship.step = Ship.step + accel
        Ship.step = maximize(Ship.step, 3)
    end
    finallyMove(Ship)
end

function finallyMove(ship)
    U:moveObject(ship)
end

function maximize(vec, size)
    local s = vec:len()
    if s <= size then
        return vec
    else
        return vec*size/s
    end
end

function fireMissile()
    Ship.holdFire = true
    Missile(Ship)
end
