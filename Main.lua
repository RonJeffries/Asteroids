-- Asteroids
-- RJ 20200511

Touches = {}

function setup()
    U = Universe()
    U:newWave()
end

function draw()
    U:draw(ElapsedTime)
    if U.attractMode then
        pushStyle()
        fontSize(50)
        fill(255,255,255, 128)
        text("TOUCH SCREEN TO START", WIDTH/2, HEIGHT/4)
        popStyle()
    end
end

function touched(touch)
    if U.attractMode and touch.state == ENDED then U:startGame(ElapsedTime) end
    if touch.state == ENDED or touch.state == CANCELLED then
        Touches[touch.id] = nil
    else
        Touches[touch.id] = touch
    end
end
