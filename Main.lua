-- Asteroids
-- RJ 20200511

Touches = {}
Ratio = 1.0 -- draw time scaling ratio
Score = 0

function setup()
    print("Hello Asteroids!")
    Score = 0
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
    drawScore()
    popStyle()
    findCollisions()
end

function drawScore()
    local s= "000000"..tostring(Score)
    s = string.sub(s,-5)
    fontSize(100)
    text(s, 200, HEIGHT-60)
end

function findCollisions()
    local KillDist = 50
    for i,a in pairs(Asteroids) do
        for k,m in pairs(Missiles) do
            if m.pos:dist(a.pos) < KillDist then
                scoreAsteroid(a)
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
