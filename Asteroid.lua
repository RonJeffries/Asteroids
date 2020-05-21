-- Asteroid
-- RJ 20200520

local Asteroids = {}
local Vel = 1.5

function createAsteroids()
    for i = 1,4 do
        table.insert(Asteroids, createAsteroid())
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
    for i,asteroid in ipairs(Asteroids) do
        drawAsteroid(asteroid)
        moveAsteroid(asteroid)
        splitAsteroid(asteroid)
    end
    popStyle()
end

function splitAsteroid(asteroid)
    if asteroid.scale == 4 then return end
    if math.random(1,960) ~= 1 then return end
    asteroid.scale = asteroid.scale//2
    asteroid.angle = math.random()*2*math.pi
    local new = createAsteroid()
    new.pos = asteroid.pos
    new.scale = asteroid.scale
    table.insert(Asteroids, new)
    Splat(asteroid.pos)
end

function drawAsteroid(asteroid)
    pushMatrix()
    pushStyle()
    translate(asteroid.pos.x, asteroid.pos.y)
    scale(asteroid.scale)
    strokeWidth(1/asteroid.scale)
    for i,l in ipairs(asteroid.shape) do
        line(l.x, l.y, l.z, l.w)
    end
    popStyle()
    popMatrix()
end

function moveAsteroid(asteroid)
    local step = vec2(Vel,0):rotate(asteroid.angle)
    local pos = asteroid.pos + step
    asteroid.pos = vec2(keepInBounds(pos.x, WIDTH), keepInBounds(pos.y, HEIGHT))
end

function keepInBounds(value, bound)
    return (value+bound)%bound
end

