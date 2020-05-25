-- Asteroids
-- RJ 20200511

Touches = {}
Ratio = 1.0 -- draw time scaling ratio
Score = 0

function setup()
    U = Universe()
    U:createAsteroids()
    Score = 0
    --displayMode(FULLSCREEN_NO_BUTTONS)
    createButtons()
    createShip()
end

function draw()
    Ratio = DeltaTime/0.0083333
    --displayMode(FULLSCREEN_NO_BUTTONS)
    checkButtons()
    pushStyle()
    background(40, 40, 50)
    U:draw()
    drawButtons()
    drawShip()
    moveShip()
    U:drawMissiles()
    drawSplats()
    drawScore()
    popStyle()
    U:findCollisions()
end

function drawScore()
    local s= "000000"..tostring(Score)
    s = string.sub(s,-5)
    fontSize(100)
    text(s, 200, HEIGHT-60)
end

function touched(touch)
    if touch.state == ENDED or touch.state == CANCELLED then
        Touches[touch.id] = nil
    else
        Touches[touch.id] = touch
    end
end
