function handle(r)

    -- Is this a websocket request?
    if r:wsupgrade() then

        -- Greet the client
        r:wswrite("Hi, this is a websocket calculator, please enter some math, or enter 'exit' to quit: \n")

        -- Read a math question from client
        local line, fin = r:wsread()
        while line do

            -- Is the client quitting?
            if line == 'exit' then break end

            -- Only allow math stuffs
            line = line:gsub("[^%s0-9%-%%+/*^%(%)]", "")

            -- Do the math
            local okay, result = pcall(loadstring("return (" .. line .. ")"))

            -- Output the result
            if okay then
                r:wswrite(line .. " = " .. result)
            else
                r:wswrite("Bad math :(")
            end

            -- Read a new math question
            line = r:wsread()
        end

        -- Bye bye!
        r:wswrite("Goodbye!")
        r:wsclose()
    	return apache2.DONE
    end
    return apache2.DECLINED
end
