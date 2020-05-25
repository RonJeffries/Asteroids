-- Missile
-- RJ 20200522

Missiles = {}

function drawMissiles()
    pushStyle()
    pushMatrix()
    fill(255)
    stroke(255)
    for k, missile in pairs(Missiles) do
        missile:draw()
    end
    popMatrix()
    popStyle()
    for k, missile in pairs(Missiles) do
        missile:move()
    end
end

Missile = class()

local MissileVelocity = 2.0

function Missile:init(ship)
    function die()
        self:die()
    end
    self.pos = ship.pos
    self.step = vec2(MissileVelocity,0):rotate(ship.radians) + ship.step
    Missiles[self] = self
    tween(3, self, {}, tween.easing.linear, die)
end

function Missile:die()
    Missiles[self] = nil
end

function Missile:draw()
    ellipse(self.pos.x, self.pos.y, 6)
end

function Missile:move()
    U:moveObject(self)
end
