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

    end)
end