-- Asteroid
-- RJ 20200520

local DeadAsteroids = {}
local Vel = 1.5

Asteroid = class()

function Asteroid:init()
    self.pos = vec2(math.random(WIDTH), math.random(HEIGHT))
    self.shape = Rocks[math.random(1,4)]
    self.scale = 16
    local angle = math.random()*2*math.pi
    self.step = Ratio*vec2(Vel,0):rotate(angle)
end

function killDist(asteroid)
    local s = asteroid.scale
    if s == 16 then return 64 elseif s == 8 then return 32 else return 16 end
end

function killDeadAsteroids(asteroids)
    for k,a in pairs(DeadAsteroids) do
        asteroids[a] = nil
    end
    DeadAsteroids = {}
end

function scoreAsteroid(asteroid)
    local s = asteroid.scale
    local inc = 0
    if s == 16 then inc = 20
    elseif s == 8 then inc = 50
    else inc = 100
    end
    Score = Score + inc
end

function splitAsteroid(asteroid, asteroids)
    if asteroid.scale == 4 then
        Splat(asteroid.pos)
        DeadAsteroids[asteroid] = asteroid
        return
    end
    asteroid.scale = asteroid.scale//2
    asteroid.angle = math.random()*2*math.pi
    local new = Asteroid()
    new.pos = asteroid.pos
    new.scale = asteroid.scale
    asteroids[new] = new
    Splat(asteroid.pos)
end

function Asteroid:draw()
    pushMatrix()
    pushStyle()
    translate(self.pos.x, self.pos.y)
    --ellipse(0,0,2*killDist(self))
    scale(self.scale)
    strokeWidth(1/self.scale)
    for i,l in ipairs(self.shape) do
        line(l.x, l.y, l.z, l.w)
    end
    popStyle()
    popMatrix()
end

function Asteroid:move()
    U:moveObject(self)
end

