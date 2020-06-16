-- Asteroids
-- RJ 20200511

Touches = {}

local Console = ""

function setup()
    U = Universe()
    runTests()
    U:newWave()
end

function runTests()
    if not CodeaUnit then return end
    local det = CodeaUnit.detailed
    CodeaUnit.detailed = false
    Console = _.execute()
    CodeaUnit.detailed = det
end

function draw()
    U:draw(ElapsedTime)
    if U.attractMode then
        pushStyle()
        fontSize(50)
        fill(255,255,255, 128)
        text("TOUCH SCREEN TO START", WIDTH/2, HEIGHT/4)
        text(Console, WIDTH/2, HEIGHT - 200)
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
