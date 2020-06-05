-- Missile
-- RJ 20200522

Missile = class()

function Missile:init(pos, step)
    function die()
        self:die()
    end
    self.pos = pos
    self.step = step 
    U:addMissile(self)
    tween(3, self, {}, tween.easing.linear, die)
end

function Missile:fromShip(ship)
    local pos = ship.pos + vec2(ship:killDist() + 1,0):rotate(ship.radians)
    local step = U.missileVelocity:rotate(ship.radians) + ship.step
    return Missile(pos, step)
end

function Missile:fromSaucer(saucer)
    local vel = U.missileVelocity:rotate(math.random()*2*math.pi) + saucer.step
    return Missile(saucer.pos, vel)
end

function Missile:die()
    U:deleteMissile(self)
end

function Missile:draw()
    ellipse(self.pos.x, self.pos.y, 6)
end

function Missile:move()
    U:moveObject(self)
end
