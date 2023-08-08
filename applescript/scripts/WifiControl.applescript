use framework "CoreWLAN"

set knownNetworkNames to {}
set theClient to my CWWiFiClient's sharedWiFiClient()
theClient's setDelegate:me

-- Get main WiFi interface
set theWiFiInterface to theClient's interface()

on disconnect()
	-- Disconnects an interface from its current network; device might automatically reconnect.
	global theWiFiInterface
	theWiFiInterface's disassociate()
end disconnect

on disableWiFi()
	-- Disables an interface entirely.
	global theWiFiInterface
	theWiFiInterface's setPower:false |error|:(missing value)
end disableWiFi

on getMACAddress()
	-- Gets the MAC address of an interface.
	global theWiFiInterface
	theWiFiInterface's hardwareAddress() as text
end getMACAddress

on getRSSI()
	-- Gets the current aggregate RSSI measurement for an interface.
	global theWiFiInterface
	theWiFiInterface's rssiValue()
end getRSSI

on getCurrentSSID()
	-- Gets the SSID of the network currently connected to.
	global theWiFiInterface
	theWiFiInterface's ssid() as text
end getCurrentSSID

on connectToNetwork(theNetworkName, thePassword)
	-- Attempts to connect to the network with the given name, using the provided password.
	global theWiFiInterface
	set theNetworks to (theWiFiInterface's scanForNetworksWithSSID:(missing value) |error|:(missing value))'s 
allObjects()
	repeat with theNetwork in theNetworks
		if theNetwork's ssid() as text is networkName then
			(theWiFiInterface's associateToNetwork:theNetworkName password:thePassword |error|:(missing 
value))
			exit repeat
		end if
	end repeat
end connectToNetwork

on getAvailableNetworks()
	-- Scans for available networks and returns the list of network SSIDs.
	global theWiFiInterface
	set theNetworks to (theWiFiInterface's scanForNetworksWithSSID:(missing value) |error|:(missing value))'s 
allObjects()
	
	set theSSIDs to {}
	repeat with theNetwork in theNetworks
		copy theNetwork's ssid() as text to end of theSSIDs
	end repeat
	return theSSIDs
end getAvailableNetworks

on startMonitoringEvents()
	-- Starts monitoring for all various WiFi events.
	global theClient
	theClient's startMonitoringEventWithType:(my CWEventTypeSSIDDidChange) |error|:(missing value)
	theClient's startMonitoringEventWithType:(my CWEventTypePowerDidChange) |error|:(missing value)
	theClient's startMonitoringEventWithType:(my CWEventTypeScanCacheUpdated) |error|:(missing value)
	repeat while true
		delay 0.1
	end repeat
end startMonitoringEvents

on ssidDidChangeForWiFiInterfaceWithName:theInterfaceName
	-- Runs when the SSID of an interface changes. Logs the new SSID.
	global theClient
	set theInterface to theClient's interfaceWithName:theInterfaceName
	log "New SSID " & theInterface's ssid() as text
end ssidDidChangeForWiFiInterfaceWithName:

on powerStateDidChangeForWiFiInterfaceWithName:theInterfaceName
	-- Runs when the WiFi is enabled/disabled
	global theWiFiInterface
	set theState to theWiFiInterface's powerOn()
	if theState is true then
		log "WiFi enabled"
	else
		log "WiFi disabled"
	end if
end powerStateDidChangeForWiFiInterfaceWithName:

on scanCacheUpdatedForWiFiInterfaceWithName:theInferfaceName
	-- Runs when the list of available networks updates. Logs when new networks are available.
	global knownNetworkNames
	set newNetworks to {}
	set currentNetworks to getAvailableNetworks()
	repeat with networkName in currentNetworks
		if networkName is not in knownNetworkNames then
			copy networkName to end of newNetworks
		end if
	end repeat
	set knownNetworkNames to currentNetworks
	
	if length of newNetworks is 1 then
		log "1 new network available: " & (newNetworks as text)
	else if length of newNetworks > 1 then
		log (((length of newNetworks) as text) & " new networks available: " & (newNetworks as text))
	end if
end scanCacheUpdatedForWiFiInterfaceWithName:
