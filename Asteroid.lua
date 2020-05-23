-- Asteroid
-- RJ 20200520

Asteroids = {}
local DeadAsteroids = {}
local Vel = 1.5

function createAsteroids()
    for i = 1,4 do
        local a = createAsteroid()
        Asteroids[a] = a
    end
end

function createAsteroid()
    local a = {}
    a.pos = vec2(math.random(WIDTH), math.random(HEIGHT))
    a.angle = math.random()*2*math.pi
    a.shape = Rocks[math.random(1,4)]
    a.scale = 16
    return a
end

function drawAsteroids()
    pushStyle()
    stroke(255)
    fill(0,0,0, 0)
    strokeWidth(2)
    rectMode(CENTER)
    for i,asteroid in pairs(Asteroids) do
        drawAsteroid(asteroid)
        moveAsteroid(asteroid)
    end
    popStyle()
    killDeadAsteroids()
end

function killDist(asteroid)
    local s = asteroid.scale
    if s == 16 then return 64 elseif s == 8 then return 32 else return 16 end
end

function killDeadAsteroids()
    for k,a in pairs(DeadAsteroids) do
        Asteroids[a] = nil
    end
    DeadAsteroids = {}
end

function deathSize()
    local i = 0
    for k, a in pairs(DeadAsteroids) do
        i = i + 1
    end
    return i
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

function splitAsteroid(asteroid)
    if asteroid.scale == 4 then
        Splat(asteroid.pos)
        DeadAsteroids[asteroid] = asteroid
        return
    end
    asteroid.scale = asteroid.scale//2
    asteroid.angle = math.random()*2*math.pi
    local new = createAsteroid()
    new.pos = asteroid.pos
    new.scale = asteroid.scale
    Asteroids[new] = new
    Splat(asteroid.pos)
end

function drawAsteroid(asteroid)
    pushMatrix()
    pushStyle()
    translate(asteroid.pos.x, asteroid.pos.y)
    ellipse(0,0,2*killDist(asteroid))
    scale(asteroid.scale)
    strokeWidth(1/asteroid.scale)
    for i,l in ipairs(asteroid.shape) do
        line(l.x, l.y, l.z, l.w)
    end
    popStyle()
    popMatrix()
end

function moveAsteroid(asteroid)
    local step = Ratio*vec2(Vel,0):rotate(asteroid.angle)
    local pos = asteroid.pos + step
    asteroid.pos = vec2(keepInBounds(pos.x, WIDTH), keepInBounds(pos.y, HEIGHT))
end

function keepInBounds(value, bound)
    return (value+bound)%bound
end

