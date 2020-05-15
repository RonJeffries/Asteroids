-- Asteroids
-- RJ 20200511

local Asteroids = {}
local Vel = 1.5
local Ship = {}
local Touches = {}
local Buttons = {}

function setup()
    print("Hello Asteroids!")
    displayMode(FULLSCREEN_NO_BUTTONS)
    createButtons()
    createAsteroids()
    createShip()
end

function createAsteroids()
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

function createButtons()
    local dx=50
    local dy=200
    table.insert(Buttons, vec2(dx,dy))
    table.insert(Buttons, vec2(dy,dx))
    table.insert(Buttons, vec2(WIDTH-dx,dy))
    table.insert(Buttons, vec2(WIDTH-dy,dx))
end

function createShip()
    Ship.pos = vec2(WIDTH, HEIGHT)/2
    Ship.ang = 0
end

function draw()
    pushStyle()
    background(40, 40, 50)
    drawButtons()
    drawShip()
    moveShip()
    drawAsteroids()
    popStyle()
end

function drawButtons()
    pushStyle()
    ellipseMode(RADIUS)
    stroke(255)
    strokeWidth(1)
    for i,b in ipairs(Buttons) do
        pushMatrix()
        translate(b.x,b.y)
        ellipse(0,0, 50)
        popMatrix()
    end
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

function touched(touch)
    if touch.state == ENDED or touch.state == CANCELLED then
        Touches[touch.id] = nil
    else
        Touches[touch.id] = touch
    end
end

