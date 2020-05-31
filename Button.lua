-- Button
-- RJ 20200520

local Buttons = {}

function createButtons()
    local dx=75
    local dy=200
    table.insert(Buttons, {x=dx, y=dy, radius=dx, name="left"})
    table.insert(Buttons, {x=dy, y=dx, radius=dx, name="right"})
    table.insert(Buttons, {x=WIDTH-dx, y=dy, radius=dx, name="fire"})
    table.insert(Buttons, {x=WIDTH-dy, y=dx, radius=dx, name = "go"})
end

function checkButtons()
    U.button.left = false
    U.button.right = false
    U.button.go = false
    U.button.fire = false
    for id,touch in pairs(Touches) do
        for i,button in ipairs(Buttons) do
            if touch.pos:dist(vec2(button.x,button.y)) < button.radius then
                U.button[button.name]=true
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
            fill(128,0,0)
        else
            fill(128,128,128,128)
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
