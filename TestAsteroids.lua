-- TestAsteroids
-- RJ 20200511
    
function testAsteroids()
    --CodeaUnit.detailed = true
    CodeaUnit.oldU = nil

    _:describe("Asteroids Tests", function()

        _:before(function()
            CodeaUnit.oldU = U
            U = Universe()
        end)

        _:after(function()
            U = CodeaUnit.oldU
        end)
        
        _:test("Hookup", function()
            _:expect( 2+1 ).is(3)
        end)
        
        _:ignore("Rotated Length", function()
            for i = 0, 1000 do
                local rand = math.random()*2*math.pi
                local v = vec2(1.5,0):rotate(rand)
                local d = v:len()
                _:expect(d > 1.495).is(true)
                _:expect(d < 1.505).is(true)
            end
        end)
        
        _:test("Some rotates go down", function()
            local angle = math.rad(-45)
            local v = vec2(1,0):rotate(angle)
            local rvx = v.x*1000//1
            local rvy = v.y*1000//1
            _:expect(rvx).is(707)
            _:expect(rvy).is(-708)
        end)
        
        _:test("Verify mod works as advertised", function()
            _:expect(100%1000).is(100)
            _:expect(1000%1000).is(0)
            _:expect(1001%1000).is(1)
            _:expect(-1%1000).is(999)
        end)
        
        _:test("Missile fired at rest", function()
            local ship = Ship()
            local missile = Missile:fromShip(ship)
            _:expect(missile.step).is(U.missileVelocity)
        end)
        
        _:test("Missile fired north", function()
            local ship = Ship()
            ship.radians = math.pi/2
            local missile = Missile:fromShip(ship)
            local mx = missile.step.x
            local my = missile.step.y
            _:expect(mx).is(0, 0.001)
            _:expect(my).is(U.missileVelocity.x, 0.001)
        end)
        
        _:test("Missile fired from moving ship", function()
            local ship = Ship()
            ship.step = vec2(1,2)
            local missile = Missile:fromShip(ship)
            local mx = missile.step.x
            local my = missile.step.y
            _:expect(mx).is(U.missileVelocity.x + 1, 0.001)
            _:expect(my).is(U.missileVelocity.y + 2, 0.001)
        end)
        
        _:test("Wave size", function()
            local u = Universe()
            u.waveSize = nil
            _:expect(u:newWaveSize()).is(4)
            _:expect(u:newWaveSize()).is(6)
            _:expect(u:newWaveSize()).is(8)
            _:expect(u:newWaveSize()).is(10)
            _:expect(u:newWaveSize()).is(11)
            _:expect(u:newWaveSize()).is(11)
        end)
        
        _:test("Asteroids added to objects", function()
            U:newWave()
            U:applyAdditions()
            _:expect(countObjects()).is(4)
        end)
      
        _:test("Missiles added to objects", function()
            _:expect(countObjects()).is(0)
            Missile(vec2(100,100), vec2(0,0))
            U:applyAdditions()
            _:expect(countObjects()).is(1)
            Missile(vec2(100,100), vec2(0,0))
            U:applyAdditions()
            _:expect(countObjects()).is(2)
        end)
        
        _:test("Saucer added to objects", function()
            _:expect(countObjects()).is(0)
            U.currentTime = ElapsedTime
            local s = Saucer()
            U:applyAdditions()
            _:expect(countObjects()).is(1)
            s:die()
        end)
             
        _:test("Ship added to objects", function()
            _:expect(countObjects()).is(0)
            Ship()
            U:applyAdditions()
            _:expect(countObjects()).is(1)
        end)
        
        
        _:test("missile vs saucer", function()
            local pos = vec2(100,100)
            U = FakeUniverse()
            local m = Missile(pos)
            local s = Saucer(pos)
            m:collide(s)
            _:expect(U:destroyedCount()).is(2)
            s:die()
        end)
        
        _:test("saucer vs missile", function()
            local pos = vec2(100,100)
            U = FakeUniverse()
            local m = Missile(pos)
            local s = Saucer(pos)
            s:collide(m)
            _:expect(U:destroyedCount()).is(2)
            s:die()
        end)
        
        _:test("asteroid vs missile", function()
            local pos = vec2(200,200)
            U = FakeUniverse()
            a = Asteroid(pos)
            m = Missile(pos)
            a:collide(m)
            _:expect(U:destroyedCount()).is(2)
        end)
         
        _:test("missile vs asteroid", function()
            local pos = vec2(200,200)
            U = FakeUniverse()
            a = Asteroid(pos)
            m = Missile(pos)
            m:collide(a)
            _:expect(U:destroyedCount()).is(2)
        end)
         
        _:test("saucer vs asteroid both ways", function()
            local pos = vec2(200,200)
            U = FakeUniverse()
            s = Saucer(pos)
            a = Asteroid(pos)
            s:collide(a)
            _:expect(U:destroyedCount()).is(2)
            U.destroyed = {}
            a:collide(s)
            _:expect(U:destroyedCount()).is(2)
            s:die()
        end)
        
        _:test("ship vs asteroid, missile, saucer", function()
            local pos = vec2(300,300)
            U = FakeUniverse()
            local ship = Ship(pos)
            local a = Asteroid(pos)
            local m = Missile(pos)
            local s = Saucer(pos)
            ship:collide(m)
            _:expect(U:destroyedCount()).is(2)
            s:die()
        end)
         
        _:test("asteroids don't mutually destruct", function()
            local pos = vec2(333,555)
            U = FakeUniverse()
            a1 = Asteroid(pos)
            a2 = Asteroid(pos)
            a1:collide(a2)
            _:expect(U:destroyedCount()).is(0)
        end)
        
        _:test("saucer missiles kill ships", function()
            local pos = vec2(123,456)
            U = FakeUniverse()
            local s = Ship(pos)
            local m = SaucerMissile(pos)
            m:collide(s)
            _:expect(U:destroyedCount()).is(2)
            U.destroyed = {}
            s:collide(m)
            _:expect(U:destroyedCount()).is(2)
        end)
        
        _:test("Asteroids increment score", function()
            local a = Asteroid()
            local m = Missile()
            local SC = Score:instance()
            _:expect(SC:score()).is(0)
            SC:addScore(a:score(m))
            _:expect(SC:score()).is(20)
            _:expect(U.score).is(nil)
        end)
        
        _:test("saucer missiles don't kill asteroids", function()
            local pos = vec2(111,222)
            U = FakeUniverse()
            local a = Asteroid(pos)
            local m = SaucerMissile(pos)
            m:collide(a)
            _:expect(U:destroyedCount()).is(0)
            _:expect(Score:instance():score()).is(0)
            U.destroyed = {}
            a:collide(m)
            _:expect(U:destroyedCount()).is(0)
            _:expect(U.score).is(0)
        end)
        
        _:test("saucer-asteroid collisions do not score", function()
            local pos = vec2(222,333)
            U = FakeUniverse()
            local s = Saucer(pos)
            local a = Asteroid(pos)
            s:collide(a)
            _:expect(U:destroyedCount()).is(2)
            _:expect(Score:instance():score()).is(0)
            U.destroyed = {}
            a:collide(s)
            _:expect(U:destroyedCount()).is(2)
            _:expect(Score:instance():score()).is(0)
            s:die()
        end)
        
        _:test("firing from south of ship", function()
            local ship = {pos=vec2(800,800), step=vec2(0,0)}
            local saucer = {pos=vec2(800,400), step=vec2(0,0), shotSpeed=2}
            local targ = Targeter(saucer,ship)
            local dir = targ:fireDirection()
            _:expect(dir).is(vec2(0,1))
        end)
        
        _:test("firing from southwest of ship", function()
            local ship = {pos=vec2(800,800), step=vec2(0,0)}
            local saucer = {pos=vec2(400,400), step=vec2(0,0), shotSpeed=2}
            local targ = Targeter(saucer,ship)
            local dir = targ:fireDirection()
            _:expect(dir.x).is(0.707, 0.005)
            _:expect(dir.y).is(0.707, 0.005)
        end)
        
        _:test("firing from south of moving ship", function()
            local ship = {pos=vec2(800,800), step=vec2(1,0)}
            local saucer = {pos=vec2(800,400), step=vec2(0,0), shotSpeed=2}
            local targ = Targeter(saucer,ship)
            local dir = targ:fireDirection()
            _:expect(dir.y).is(0.86, 0.05)
        end)
        
        _:test("firing from moving saucer south of moving ship", function()
            local ship = {pos=vec2(800,800), step=vec2(1,0)}
            local saucer = {pos=vec2(800,400), step=vec2(1,0), shotSpeed=2}
            local targ = Targeter(saucer,ship)
            local dir = targ:fireDirection()
            _:expect(dir).is(vec2(0,1))
        end)
        
        _:test("firing from moving saucer south of anti-moving ship", function()
            local ship = {pos=vec2(800,800), step=vec2(1,0)}
            local saucer = {pos=vec2(800,400), step=vec2(-1,0), shotSpeed=4}
            local targ = Targeter(saucer,ship)
            local dir = targ:fireDirection()
            _:expect(dir.x).is(0.5, 0.05)
            _:expect(dir:len()).is(1,0.01)
        end)
        
    end)
end

function countObjects()
    local c = 0
    for k,v in pairs(U.objects) do
        c = c + 1
    end
    return c
end

FakeUniverse = class()

function FakeUniverse:init()
    Score()
    self.attractMode = true
    self.sounds = U.sounds -- U is present. See before().
    self.currentTime = ElapsedTime
    self.score = 0
    self.destroyed = {}
end

function FakeUniverse:deleteObject(anObject)
    self.destroyed[anObject] = anObject
end

function FakeUniverse:destroyedCount()
    return self:count(self.destroyed)
end

function FakeUniverse:count(aTable)
    local c = 0
    for k,v in pairs(aTable) do
        c = c + 1
    end
    return c
end

function FakeUniverse:addObject(ignored)
end

function FakeUniverse:addIndestructible(ignored)
end

function FakeUniverse:playStereo()
end
