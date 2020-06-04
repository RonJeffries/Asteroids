-- Missile
-- RJ 20200522

Missile = class()

function Missile:init(ship)
    function die()
        self:die()
    end
    self.pos = ship.pos
    self.step = U.missileVelocity:rotate(ship.radians) + ship.step
    U:addMissile(self)
    tween(3, self, {}, tween.easing.linear, die)
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
