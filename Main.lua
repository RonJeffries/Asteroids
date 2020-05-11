-- Asteroids
-- RJ 20200511

function setup()
    print("Hello Asteroids!")
    X = 400
    Y = 500
end

function draw()
    background(40, 40, 50)
    strokeWidth(1)
    stroke(255)
    fill(40, 40,50)
    ellipseMode(CENTER)
    ellipse(X,Y, 120)
    X = X + 1
    if X > WIDTH then X = X - WIDTH end
    if X < 0 then X = X + WIDTH end
    Y = Y + 2
    if Y > HEIGHT then Y = Y - HEIGHT end
    if Y < 0 then Y = Y + HEIGHT end
end

