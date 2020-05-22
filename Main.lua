-- Asteroids
-- RJ 20200511

Touches = {}

function setup()
    print("Hello Asteroids!")
    --displayMode(FULLSCREEN_NO_BUTTONS)
    createButtons()
    createAsteroids()
    createShip()
end

function draw()
    checkButtons()
    --displayMode(FULLSCREEN_NO_BUTTONS)
    pushStyle()
    background(40, 40, 50)
    drawButtons()
    drawShip()
    moveShip()
    drawMissiles()
    drawAsteroids()
    drawSplats()
    popStyle()
end

function touched(touch)
    if touch.state == ENDED or touch.state == CANCELLED then
        Touches[touch.id] = nil
    else
        Touches[touch.id] = touch
    end
end
