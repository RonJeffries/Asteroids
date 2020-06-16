-- Missile
-- RJ 20200522

Missile = class(Destructible)

function Missile:init(pos, step)
    function die()
        self:die()
    end
    self.pos = pos
    self.step = step 
    U:addObject(self)
    tween.delay(3, die)
end

function Missile:fromShip(ship)
    local pos = ship.pos + vec2(ship:killDist() + 1,0):rotate(ship.radians)
    local step = U.missileVelocity:rotate(ship.radians) + ship.step
    return Missile(pos, step)
end

function Missile:die()
    U:deleteObject(self)
end

function Missile:score()
    return 0
end

function Missile:draw()
    pushStyle()
    pushMatrix()
    fill(255)
    stroke(255)
    ellipse(self.pos.x, self.pos.y, 6)
    popMatrix()
    popStyle()
end

function Missile:move()
    U:moveObject(self)
end

function Missile:killDist()
    return 0
end
