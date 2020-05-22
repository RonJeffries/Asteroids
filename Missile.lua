-- Missile
-- RJ 20200522

local Missiles = {}

function drawMissiles()
    pushStyle()
    pushMatrix()
    fill(255)
    stroke(255)
    for i,missile in ipairs(Missiles) do
        ellipse(missile.pos.x, missile.pos.y, 6)
    end
    popMatrix()
    popStyle()
    for i, missile in ipairs(Missiles) do
        missile.pos = missile.pos + missile.vel
        missile.pos = vec2(keepInBounds(missile.pos.x, WIDTH), keepInBounds(missile.pos.y, HEIGHT))
    end
end

Missile = class()

local MissileVelocity = 2.0

function Missile:init(ship)
    self.pos = ship.pos
    self.vel = vec2(MissileVelocity,0):rotate(math.rad(ship.ang))
    table.insert(Missiles, self)
end

function Missile:draw()
end

