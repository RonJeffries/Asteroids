-- Button
-- RJ 20200520

local Buttons = {}

function createButtons()
    local dx=75
    local dy=200
    local cen = vec2(125,125)
    U.button.turnCenter = cen
    table.insert(Buttons, {x=cen.x, y=cen.y, radius=125, name="turn"})
    table.insert(Buttons, {x=WIDTH-dx, y=dy, radius=dx, name="fire"})
    table.insert(Buttons, {x=WIDTH-dy, y=dx, radius=dx, name = "go"})
end

function checkButtons()
    U.button.left = false
    U.button.right = false
    U.button.turn = false
    U.button. turnPos = nil
    U.button.go = false
    U.button.fire = false
    for id,touch in pairs(Touches) do
        for i,button in ipairs(Buttons) do
            if touch.pos:dist(vec2(button.x,button.y)) < button.radius then
                U.button[button.name]=true
                if button.name == "turn" then
                    U.button.turnPos = touch.pos
                end
            end
        end
    end
end

function drawButtons()
    pushStyle()
    ellipseMode(RADIUS)
    textMode(CENTER)
    stroke(255)
    strokeWidth(1)
    for i,b in ipairs(Buttons) do
        pushMatrix()
        pushStyle()
        translate(b.x,b.y)
        if U.button[b.name] then
            fill(128,0,0, 32)
        else
            fill(128,128,128,32)
        end
        ellipse(0,0, b.radius)
        fill(255)
        fontSize(30)
        text(b.name,0,0)
        popStyle()
        popMatrix()
    end
    popStyle()
end
