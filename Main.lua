-- Asteroids
-- RJ 20200511

local Asteroids = {}
local Vel = 1.5
local Ship = {}
local Touches = {}
local Buttons = {}
local Button = {}

function setup()
   print("Hello Asteroids!")
   displayMode(FULLSCREEN_NO_BUTTONS)
   createButtons()
   createAsteroids()
   createShip()
end

function createAsteroids()
   for i = 1,10 do
       table.insert(Asteroids, createAsteroid())
   end
end

function createAsteroid()
   local a = {}
   a.pos = vec2(math.random(WIDTH), math.random(HEIGHT))
   a.angle = math.random()*2*math.pi
   return a
end

function createButtons()
   local dx=50
   local dy=200
   table.insert(Buttons, {x=dx, y=dy, name="left"})
   table.insert(Buttons, {x=dy, y=dx, name="right"})
   table.insert(Buttons, {x=WIDTH-dx, y=dy, name="fire"})
   table.insert(Buttons, {x=WIDTH-dy, y=dx, name = "go"})
end

function createShip()
   Ship.pos = vec2(WIDTH, HEIGHT)/2
   Ship.ang = 0
end

function draw()
   checkButtons()
   displayMode(FULLSCREEN_NO_BUTTONS)
   pushStyle()
   background(40, 40, 50)
   drawButtons()
   drawShip()
   moveShip()
   drawAsteroids()
   drawNewAsteroid()
   popStyle()
end

function checkButtons()
   Button.left = false
   Button.right = false
   Button.go = false
   Button.fire = false
   for id,touch in pairs(Touches) do
       for i,button in ipairs(Buttons) do
           if touch.pos:dist(vec2(button.x,button.y)) < 50 then
               Button[button.name]=true
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
       if Button[b.name] then
           fill(128,0,0)
       else
           fill(128,128,128,128)
       end
       ellipse(0,0, 50)
       fill(255)
       fontSize(30)
       text(b.name,0,0)
       popStyle()
       popMatrix()
   end
   popStyle()
end

function drawNewAsteroid()
   local m = 2
local a = {--vec2(0,1),
vec2(1,1),
vec2(1,-1),
vec2(-1,-2)/m,
vec2(1,-2)/m,
vec2(-3,-2)/m,
vec2(-3,0)/m,
vec2(-1,1),
vec2(0, 2),
vec2(1,1),
vec2(1,-1)}
   pushStyle()
   pushMatrix()
   stroke(255)
   local from = vec2(0,1)
   translate(WIDTH/2, HEIGHT/2 +100)
   fill(255)
   ellipse(0,0,5)
   local s = 25
   scale(s)
   strokeWidth(1.0/s)
   for i,v in ipairs(a) do
       local n = 1
       local t = from+v
       line(n*from.x, n*from.y, n*t.x,n*t.y)
       from = vec2(t.x,t.y)
   end
   Once = false
   popMatrix()
   popStyle()
end

function drawShip()
   local sx = 10
   local sy = 6
   pushStyle()
   pushMatrix()
   translate(Ship.pos.x, Ship.pos.y)
   rotate(Ship.ang)
   strokeWidth(2)
   stroke(255)
   line(sx,0, -sx,sy)
   line(-sx,sy, -sx,-sy)
   line(-sx,-sy, sx,0)
   popMatrix()
   popStyle()
end

function moveShip()
   if Button.left then Ship.ang = Ship.ang + 1 end
   if Button.right then Ship.ang = Ship.ang - 1 end
end

function drawAsteroids()
   pushStyle()
   stroke(255)
   fill(0,0,0, 0)
   strokeWidth(2)
   rectMode(CENTER)
   for i,asteroid in ipairs(Asteroids) do
       drawAsteroid(asteroid)
       moveAsteroid(asteroid)
   end
   popStyle()
end

function drawAsteroid(asteroid)
   rect(asteroid.pos.x, asteroid.pos.y, 120)
end

function moveAsteroid(asteroid)
   local step = vec2(Vel,0):rotate(asteroid.angle)
   local pos = asteroid.pos + step
   asteroid.pos = vec2(keepInBounds(pos.x, WIDTH), keepInBounds(pos.y, HEIGHT))
end

function keepInBounds(value, bound)
   return (value+bound)%bound
end

function touched(touch)
   if touch.state == ENDED or touch.state == CANCELLED then
       Touches[touch.id] = nil
   else
       Touches[touch.id] = touch
   end
end
