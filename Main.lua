-- Asteroids
-- RJ 20200511

Touches = {}

local Console = ""

function setup()
    parameter.boolean("FullScreen", false)
    parameter.integer("NumberOfShips", 2,5,4)
    parameter.boolean("InfiniteShips", false)
    parameter.boolean("NoAsteroids", false)
    parameter.boolean("PerfectSaucerShots", false)
    parameter.boolean("Fancy", true)
    U = Universe()
    runTests()
    print(zLevel())
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
    if U.attractMode then
        pushMatrix()
        pushStyle()
        if Fancy then
            translate(WIDTH/2,HEIGHT/2)
            scale(WIDTH/137,HEIGHT/91)
            sprite(asset.milkyway)
            popStyle()
            popMatrix()
            pushMatrix()
            pushStyle()
        end
        fontSize(50)
        fill(255,255,255, 128)
        text("TOUCH SCREEN TO START", WIDTH/2, HEIGHT/4)
        text(Console, WIDTH/2, HEIGHT - 200)
        popStyle()
        popMatrix()
    end
    U:draw(ElapsedTime)
end

function touched(touch)
    if U.attractMode and touch.state == ENDED then U:startGame(ElapsedTime) end
    if touch.state == ENDED or touch.state == CANCELLED then
        Touches[touch.id] = nil
    else
        Touches[touch.id] = touch
    end
end
