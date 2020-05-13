-- Asteroids
-- RJ 20200511

local Asteroids = {}
local Vel = 1.5

function setup()
    print("Hello Asteroids!")
    for i = 1,10 do
        table.insert(Asteroids, createAsteroid())
    end
end

function createAsteroid()
    local a = {}
    a.pos = vec2(math.random(WIDTH), math.random(HEIGHT))
    a.angle = math.random()*2*math.pi
    return a
end

function draw()
    pushStyle()
    background(40, 40, 50)
    drawAsteroids()
    popStyle()
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
    end
    popStyle()
end

function drawAsteroid(asteroid)
    rect(asteroid.pos.x, asteroid.pos.y, 120)
end

function moveAsteroid(asteroid)
    local step = vec2(Vel,0):rotate(asteroid.angle)
    local pos = asteroid.pos + step
    asteroid.pos = vec2(putInBounds(pos.x, WIDTH), putInBounds(pos.y, HEIGHT))
end

function putInBounds(value, bound)
    return (value+bound)%bound
end