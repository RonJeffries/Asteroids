-- Asteroids
-- RJ 20200511

Touches = {}
Ratio = 1.0 -- draw time scaling ratio

function setup()
    print("Hello Asteroids!")
    --displayMode(FULLSCREEN_NO_BUTTONS)
    createButtons()
    createAsteroids()
    createShip()
end

function draw()
    Ratio = 0.0083333/DeltaTime
    --displayMode(FULLSCREEN_NO_BUTTONS)
    checkButtons()
    pushStyle()
    background(40, 40, 50)
    drawButtons()
    drawShip()
    moveShip()
    drawMissiles()
    drawAsteroids()
    drawSplats()
    popStyle()
    findCollisions()
end

function findCollisions()
    local KillDist = 50
    for i,a in pairs(Asteroids) do
        for k,m in pairs(Missiles) do
            if m.pos:dist(a.pos) < KillDist then
                splitAsteroid(a)
                m:die()
            end
        end
    end
end

function touched(touch)
    if touch.state == ENDED or touch.state == CANCELLED then
        Touches[touch.id] = nil
    else
        Touches[touch.id] = touch
    end
end
