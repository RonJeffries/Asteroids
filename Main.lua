-- Asteroids
-- RJ 20200511

Touches = {}

function setup()
    U = Universe()
    U:createAsteroids()
    Score = 0
end

function draw()
    U:draw()
end

function touched(touch)
    if touch.state == ENDED or touch.state == CANCELLED then
        Touches[touch.id] = nil
    else
        Touches[touch.id] = touch
    end
end
