-- Universe
-- RJ 20200523

Universe = class()

local MissileSpeed = 2.0

function Universe:init()
    self.asteroids = {}
    self.missiles = {}
    self.missileVelocity = vec2(MissileSpeed,0)
end

function Universe:draw()
    self:drawAsteroids()
end

function Universe:createAsteroids()
    createAsteroids(self.asteroids)
end

function Universe:findCollisions()
    for i,a in pairs(self.asteroids) do
        for k,m in pairs(self.missiles) do
            if m.pos:dist(a.pos) < killDist(a) then
                scoreAsteroid(a)
                splitAsteroid(a, self.asteroids)
                m:die()
            end
        end
    end
end

function Universe:moveObject(anObject)
    local pos = anObject.pos + Ratio*anObject.step
    anObject.pos = vec2(self:keepInBounds(pos.x, WIDTH), self:keepInBounds(pos.y, HEIGHT))    
end

function Universe:keepInBounds(value, bound)
    return (value+bound)%bound
end

function Universe:drawMissiles()
    pushStyle()
    pushMatrix()
    fill(255)
    stroke(255)
    for k, missile in pairs(self.missiles) do
        missile:draw()
    end
    popMatrix()
    popStyle()
    for k, missile in pairs(self.missiles) do
        missile:move()
    end
end

function Universe:drawAsteroids()
    pushStyle()
    stroke(255)
    fill(0,0,0, 0)
    strokeWidth(2)
    rectMode(CENTER)
    for i,asteroid in pairs(self.asteroids) do
        asteroid:draw()
        asteroid:move()
    end
    popStyle()
    killDeadAsteroids(self.asteroids)
end


