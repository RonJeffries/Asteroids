-- Asteroids
-- RJ 20200511

function setup()
    print("Hello Asteroids!")
    Pos = vec2(400,500)
    Angle = math.random()*2*math.pi
    Vel = 1.5
end

function draw()
    background(40, 40, 50)
    stroke(255)
    fill(40, 40,50)
    strokeWidth(2)
    rectMode(CENTER)
    rect(Pos.x, Pos.y, 120)
    local step = vec2(Vel,0):rotate(Angle)
    Pos = Pos + step
    if Pos.x > WIDTH then Pos.x = Pos.x - WIDTH end
    if Pos.x < 0 then Pos.x = Pos.x + WIDTH end
    if Pos.y > HEIGHT then Pos.y = Pos.y - HEIGHT end
    if Pos.y < 0 then Pos.y = Pos.y + HEIGHT end
end

