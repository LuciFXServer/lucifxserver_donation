local donationList = {}

function refreshData ()
	donationList = {}
	MySQL.ready(function()
		MySQL.Async.fetchAll('SELECT * FROM donator', {}, function(donator)
			for i=1, #donator, 1 do
				local priority = false
				local notification = false
				if (donator[i].priority == 1) then 
					priority = true
				end 
				if (donator[i].notification == 1) then 
					notification = true
				end 
				if (donator[i].level >= 2) then 
					ExecuteCommand('add_principal identifier.'..donator[i].ident..' group.vip')
				end

				table.insert(donationList, {
					identification = donator[i].ident,
					donationLevel = donator[i].level,
					priority = priority,
					notification = notification,
				})
			end

			Queue.OnReady(function() 
				local startCount = 40
				local prioritize = {}
			    for x,i in ipairs(donationList) do
			    	if (i['priority'] == true) then 
				    	Queue.AddPriority(i['identification'], x+startCount)
				    end
			    end
			end)
		end)
	end)
end
refreshData()

AddEventHandler('es:playerLoaded', function(source)
	local foundIdnt = false
	local theLevel = 0 
	local notifs = false
	for k,v in ipairs(GetPlayerIdentifiers(source)) do
		for x,i in ipairs(donationList) do
			if (string.lower(i['identification']) == string.lower(v)) then 
				foundIdnt = true
				theLevel = i["donationLevel"]
				notifs = i["notification"]
			end
		end
	end

	if (foundIdnt == true) then 
		TriggerClientEvent('chat:addMessage', source, {
	          template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(255,215,0, 0.6);color: white; border-radius: 3px;"><i class="fas fa-user-shield"></i> <font color="#FFFFFF">Welcome back {0}! Your current donation level is {1}.</font></div>',
	          args = { GetPlayerName(source) , theLevel}
	      })
		if (notifs == true) then 
			TriggerClientEvent("pNotify:SendNotification", -1, {
	            text = GetPlayerName(source).." has logged in with Donator Level "..theLevel,
	            type = "info",
	            timeout = 5000,
	            layout = "topCenter"
	        })
		end
	end 
end)

function isPlayerADonator (theSource)
	local foundIdnt = false
	local theLevel = 0

	local steamFound = false
	local licenseIdent = ""
	local licenseFound = false
	for k,v in ipairs(GetPlayerIdentifiers(theSource)) do
		for x,i in ipairs(donationList) do
			local identifySteam = string.sub(string.lower(i['identification']), 1, 5)
			if identifySteam == "steam" then
				if (string.lower(i['identification']) == string.lower(v)) then 
					foundIdnt = true
					theLevel = i["donationLevel"]
					steamFound = true
				end
			else
				if (string.lower(i['identification']) == string.lower(v)) then 
					foundIdnt = true
					theLevel = i["donationLevel"]
					licenseIdent = i["identification"]
					licenseFound = true
				end
			end 
		end
	end

	if (licenseFound == true and steamFound == true) then 
		MySQL.Async.execute('DELETE FROM donator WHERE ident = @ident', {
			['@ident']   = licenseIdent
		}, function(rowsChanged)
			refreshData()
		end)
	end 

	return theLevel
end 

RegisterCommand("adddonator", function(source, args, rawCommand)
    if (source == 0) then 
    	local hex = args[1]
    	MySQL.Async.execute('INSERT INTO donator (ident, level, priority, notification) VALUES (@ident, @level, @priority, @notification)', {
			['@ident']   = hex,
			['@level']  = args[2],
			['@priority'] = args[3],
			['@notification']  = true
		}, function(rowsChanged)
			local priority = false
			if (args[3] == 1) then 
				priority = true
			end

			table.insert(donationList, {
				identification = hex,
				donationLevel = args[2],
				priority = priority,
				notification = notification,
			})

			Queue.OnReady(function() 
				local startCount = 40
				local prioritize = {}
			    for x,i in ipairs(donationList) do
			    	if (i['priority'] == true) then 
				    	Queue.AddPriority(i['identification'], x+startCount)
				    end
			    end
			end)
			if (tonumber(args[2]) == 4) then
				TriggerClientEvent('chat:addMessage', -1, {
	                template = '<div style="padding: 0.5vw; margin: 0.5vw; background: linear-gradient(124deg, #ff2400, #e81d1d, #e8b71d, #e3e81d, #1de840, #1ddde8, #2b1de8, #dd00f3, #dd00f3); background-size: 1800% 1800%; -webkit-animation: rainbow 18s ease infinite; -z-animation: rainbow 18s ease infinite; -o-animation: rainbow 18s ease infinite; animation: rainbow 18s ease infinite; color: white; border-radius: 3px;"><i class="fas fa-globe"></i> <i class="fas fa-user-shield"></i> <font color="#FFFFFF">Donation: '..args[4]..' just bought Donator Tier 4!</font></div>',
	                args = {fal, args[4].." just bought Donator T4!", {255, 127, 0}, "Donation"}
	            })
	            TriggerClientEvent("pNotify:SendNotification", -1, {
		            text = args[4].." just bought Donator T4!",
		            type = "info",
		            timeout = 5000,
		            layout = "topCenter"
		        })
			end
		end)
    else
    	print ("ID: "..source.." trying to run the adddonator.")
    end
end)

RegisterCommand("removedonator", function(source, args, rawCommand)
    if (source == 0) then 
    	local hex = args[1]
    	MySQL.Async.execute('DELETE FROM donator WHERE ident = @ident', {
			['@ident']   = hex
		}, function(rowsChanged)
			refreshData()
		end)
    else
    	print ("ID: "..source.." trying to run the removedonator.")
    end
end)

RegisterCommand("demotedonator", function(source, args, rawCommand)
    if (source == 0) then 
    	local hex = args[1]
    	MySQL.Async.execute('UPDATE donator SET level = 1 WHERE ident = @ident', {
			['@ident'] = hex
		}, function(rowsChanged)
			refreshData()
		end)
    else
    	print ("ID: "..source.." trying to run the demotedonator.")
    end
end)