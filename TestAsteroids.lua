-- TestAsteroids
-- RJ 20200511
    
function testAsteroids()
    CodeaUnit.detailed = true

    _:describe("Asteroids First Tests", function()

        _:before(function()
            -- Some setup
        end)

        _:after(function()
            -- Some teardown
        end)
        
        _:test("Hookup", function()
            _:expect( 2+1 ).is(3)
        end)
        
        _:test("Random", function()
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
        
        _:test("Bounds function", function()
            _:expect(U:keepInBounds(100,1000)).is(100)
            _:expect(U:keepInBounds(1000,1000)).is(0)
            _:expect(U:keepInBounds(1001,1000)).is(1)
            _:expect(U:keepInBounds(-1,1000)).is(999)
        end)
        
        _:test("Missile fired at rest", function()
            createShip()
            local missile = Missile(U.ship)
            _:expect(missile.step).is(U.missileVelocity)
        end)
        
        _:test("Missile fired north", function()
            createShip()
            U.ship.radians = math.pi/2
            local missile = Missile(U.ship)
            local mx = missile.step.x
            local my = missile.step.y
            _:expect(mx).is(0, 0.001)
            _:expect(my).is(U.missileVelocity.x, 0.001)
        end)
        
        _:test("Missile fired from moving ship", function()
            createShip()
            U.ship.step = vec2(1,2)
            local missile = Missile(U.ship)
            local mx = missile.step.x
            local my = missile.step.y
            _:expect(mx).is(U.missileVelocity.x + 1, 0.001)
            _:expect(my).is(U.missileVelocity.y + 2, 0.001)
        end)

    end)
end
