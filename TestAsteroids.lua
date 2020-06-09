-- TestAsteroids
-- RJ 20200511
    
function testAsteroids()
    CodeaUnit.detailed = true
    CodeaUnit.oldU = nil

    _:describe("Asteroids First Tests", function()

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
        
        _:ignore("Random", function()
            local min = 100
            local max = 0
            for i = 0,1000 do
                local rand = math.random()*2*math.pi
                if rand < min then min = rand end
                if rand > max then max = rand end
            end
            _:expect(min < 0.01).is(true)
            _:expect(max > 6.2).is(true)
        end)
        
        _:test("Rotated Length", function()
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
        
        _:test("Asteroids increment score", function()
            local a = Asteroid()
            U.score = 0
            a:score()
            _:expect(U.score).is(20)
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
        
        _:ignore("Trigger New Wave", function()
            local u = Universe()
            _:expect(u.timeOfNextWave).is(0)
            u.asteroids = {}
            u:draw(666)
            _:expect(u.timeOfNextWave).is(668, .05)
            u:draw(668)
            _:expect(u.timeOfNextWave).is(0)
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
            Saucer()
            U:applyAdditions()
            _:expect(countObjects()).is(1)
        end)
             
        _:test("Ship added to objects", function()
            _:expect(countObjects()).is(0)
            Ship()
            U:applyAdditions()
            _:expect(countObjects()).is(1)
        end)
        
        _:test("Explosion added to objects", function()
            _:expect(countObjects()).is(0)
            Ship()
            U:applyAdditions()
            _:expect(countObjects()).is(1)
            Explosion(Ship:instance())
            U:applyAdditions()
            _:expect(countObjects()).is(2)
        end)
        
        _:test("missile hits saucer", function()
            local pos = vec2(100,100)
            U = FakeUniverse()
            local m = Missile(pos)
            local s = Saucer(pos)
            m:collide(s)
            _:expect(U:destroyedCount()).is(2)
        end)
        
        _:test("saucer hits missile", function()
            local pos = vec2(100,100)
            U = FakeUniverse()
            local m = Missile(pos)
            local s = Saucer(pos)
            s:collide(m)
            _:expect(U:destroyedCount()).is(2)
        end)
        
        _:ignore("deadly collisions", function()
            local pos = vec2(200,200)
            local candidates = { Missile(pos), Asteroid(pos), Ship(pos) }
            for k,c in ipairs(candidates) do
                for kk, cc in ipairs(candidates) do
                    if cc ~= c then
                        U = FakeUniverse()
                        c:collide(cc)
                        _:expect(U:destroyedCount()).is(2)
                        U = FakeUniverse()
                        cc:collide(c)
                        _:expect(U:destroyedCount()).is(2)
                    end
                end
            end
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
    self.currentTime = ElapsedTime
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

function FakeUniverse:addObject(missile)
    self.missile = missile
end
