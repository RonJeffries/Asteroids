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
    background(40, 40, 50)
    drawAsteroids()
end

function drawAsteroids()
    stroke(255)
    fill(40, 40,50)
    strokeWidth(2)
    rectMode(CENTER)
    for i,asteroid in ipairs(Asteroids) do
        drawAsteroid(asteroid)
    end
end

function drawAsteroid(asteroid)
    rect(asteroid.pos.x, asteroid.pos.y, 120)
    moveAsteroid(asteroid)
end

function moveAsteroid(asteroid)
    local step = vec2(Vel,0):rotate(asteroid.angle)
    asteroid.pos = asteroid.pos + step
    if asteroid.pos.x > WIDTH then asteroid.pos.x = asteroid.pos.x - WIDTH end
    if asteroid.pos.x < 0 then asteroid.pos.x = asteroid.pos.x + WIDTH end
    if asteroid.pos.y > HEIGHT then asteroid.pos.y = asteroid.pos.y - HEIGHT end
    if asteroid.pos.y < 0 then asteroid.pos.y = asteroid.pos.y + HEIGHT end
end