-- Asteroids
-- RJ 20200511

function setup()
    print("Hello Asteroids!")
    Asteroids = {}
    local asteroid = {}
    asteroid.pos = vec2(math.random(WIDTH), math.random(HEIGHT))
    asteroid.angle = math.random()*2*math.pi
    table.insert(Asteroids,asteroid)
    asteroid = {}
    asteroid.pos = vec2(math.random(WIDTH), math.random(HEIGHT))
    asteroid.angle = math.random()*2*math.pi
    table.insert(Asteroids,asteroid)
    Vel = 1.5
end

function draw()
    background(40, 40, 50)
    stroke(255)
    fill(40, 40,50)
    strokeWidth(2)
    rectMode(CENTER)
    for i,asteroid in ipairs(Asteroids) do
        rect(asteroid.pos.x, asteroid.pos.y, 120)
        local step = vec2(Vel,0):rotate(asteroid.angle)
        asteroid.pos = asteroid.pos + step
        if asteroid.pos.x > WIDTH then asteroid.pos.x = asteroid.pos.x - WIDTH end
        if asteroid.pos.x < 0 then asteroid.pos.x = asteroid.pos.x + WIDTH end
        if asteroid.pos.y > HEIGHT then asteroid.pos.y = asteroid.pos.y - HEIGHT end
        if asteroid.pos.y < 0 then asteroid.pos.y = asteroid.pos.y + HEIGHT end
    end
end

