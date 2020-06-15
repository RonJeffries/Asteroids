CodeaUnit = class()

function CodeaUnit:describe(feature, allTests)
    self.tests = 0
    self.ignored = 0
    self.failures = 0
    self._before = function()
    end
    self._after = function()
    end

    _._print(string.format("Feature: %s", feature))

    allTests()

    local passed = self.tests - self.failures - self.ignored
    local summary = string.format("%d Passed, %d Ignored, %d Failed", passed, self.ignored, self.failures)

    _._print(summary)
end

function CodeaUnit:before(setup)
    self._before = setup
end

function CodeaUnit:after(teardown)
    self._after = teardown
end

function CodeaUnit:ignore(description, scenario)
    self.description = tostring(description or "")
    self.tests = self.tests + 1
    self.ignored = self.ignored + 1
    if CodeaUnit.detailed then
        _._print(string.format("%d: %s -- Ignored", self.tests, self.description))
    end
end

function CodeaUnit:test(description, scenario)
    self.description = tostring(description or "")
    self.tests = self.tests + 1
    self._before()
    local status, err = pcall(scenario)
    if err then
        self.failures = self.failures + 1
        _._print(string.format("%d: %s -- %s", self.tests, self.description, err))
    end
    self._after()
end

function CodeaUnit:expect(conditional)
    local message = string.format("%d: %s", (self.tests or 1), self.description)

    local passed = function()
        if CodeaUnit.detailed then
            _._print(string.format("%s -- OK", message))
        end
    end

    local failed = function()
        self.failures = self.failures + 1
        local actual = tostring(conditional)
        local expected = tostring(self.expected)
        _._print(string.format("%s -- Actual: %s, Expected: %s", message, actual, expected))
    end

    local notify = function(result)
        if result then
            passed()
        else
            failed()
        end
    end

    local is = function(expected, epsilon)
        self.expected = expected
        if epsilon then
            notify(expected - epsilon <= conditional and conditional <= expected + epsilon)
        else
            notify(conditional == expected)
        end
    end

    local isnt = function(expected)
        self.expected = expected
        notify(conditional ~= expected)
    end

    local has = function(expected)
        self.expected = expected
        local found = false
        for i,v in pairs(conditional) do
            if v == expected then
                found = true
            end
        end
        notify(found)
    end

    local hasnt = function(expected)
        self.expected = expected
        local missing = true
        for i,v in pairs(conditional) do
            if v == expected then
                missing = false
            end
        end
        notify(missing)
    end
    
    local throws = function(expected)
        self.expected = expected
        local status, error = pcall(conditional)
        if not error then
            conditional = "nothing thrown"
            notify(false)
        else
            notify(string.find(error, expected, 1, true))
        end
    end

    return {
        is = is,
        isnt = isnt,
        has = has,
        hasnt = hasnt,
        throws = throws
    }
end

CodeaUnit.execute = function(detailed)
    if detailed == nil then
        CodeaUnit.detailed = true
    else
        CodeaUnit.detailed = detailed
    end
    for i,v in pairs(listProjectTabs()) do
        local source = readProjectTab(v)
        for match in string.gmatch(source, "function%s-(test.-%(%))") do
            print("loading", match)
            loadstring(match)()
        end
    end
end

function CodeaUnit.executeToString(detailed)
    --print("executing detailed ", detailed)
    _.console = ""
    CodeaUnit.execute(detailed)
    local c = _.console
    --print("console:\n", _.console)
    _.console = nil
    return c
end


CodeaUnit.detailed = true


CodeaUnit._print = function(x)
    --print("print ", string.len(_.console), x)
    if _.console ~= nil then
        _.console = _.console .. x .. "\n"
    else
        print(x)
    end
end

_ = CodeaUnit()

parameter.action("CodeaUnit Runner", function()
    CodeaUnit.execute()
end)