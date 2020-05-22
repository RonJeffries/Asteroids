-- Missile
-- RJ 20200522

local Missiles = {}

function drawMissiles()
    pushStyle()
    pushMatrix()
    fill(255)
    stroke(255)
    for k, missile in pairs(Missiles) do
        ellipse(missile.pos.x, missile.pos.y, 6)
    end
    popMatrix()
    popStyle()
    for k, missile in pairs(Missiles) do
        missile.pos = missile.pos + missile.vel
        missile.pos = vec2(keepInBounds(missile.pos.x, WIDTH), keepInBounds(missile.pos.y, HEIGHT))
    end
end

Missile = class()

local MissileVelocity = 2.0

function Missile:init(ship)
    function die()
        Missiles[self] = nil
    end
    self.pos = ship.pos
    self.vel = vec2(MissileVelocity,0):rotate(math.rad(ship.ang))
    Missiles[self] = self
    tween(3, self, {}, tween.easing.linear, die)
end

function Missile:draw()
end

