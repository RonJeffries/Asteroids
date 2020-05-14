-- Asteroids
-- RJ 20200511

local Asteroids = {}
local Vel = 1.5
local Ship = {}

function setup()
    print("Hello Asteroids!")
    for i = 1,10 do
        table.insert(Asteroids, createAsteroid())
    end
    createShip()
end

function createAsteroid()
    local a = {}
    a.pos = vec2(math.random(WIDTH), math.random(HEIGHT))
    a.angle = math.random()*2*math.pi
    return a
end

function createShip()
    Ship.pos = vec2(WIDTH, HEIGHT)/2
    Ship.ang = 0
end

function draw()
    pushStyle()
    background(40, 40, 50)
    drawShip()
    moveShip()
    drawAsteroids()
    popStyle()
end

function drawShip()
    local sx = 10
    local sy = 6
    pushStyle()
    pushMatrix()
    translate(Ship.pos.x, Ship.pos.y)
    rotate(Ship.ang)
    strokeWidth(2)
    stroke(255)
    line(sx,0, -sx,sy)
    line(-sx,sy, -sx,-sy)
    line(-sx,-sy, sx,0)
    popMatrix()
    popStyle()
end

function moveShip()
    local delta = 0
    if CurrentTouch.state == BEGAN then
        if CurrentTouch.pos.x < WIDTH/2 then
            delta = 1
        else
            delta = -1
        end
    end
    if CurrentTouch.state == ENDED then
        delta = 0
    end
    Ship.ang = Ship.ang + delta
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
    asteroid.pos = vec2(keepInBounds(pos.x, WIDTH), keepInBounds(pos.y, HEIGHT))
end

function keepInBounds(value, bound)
    return (value+bound)%bound
end
