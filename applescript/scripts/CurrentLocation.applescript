use framework "CoreLocation"
use scripting additions

set theLocation to (missing value)
set maxSeconds to 10
set timeStarted to (current date)

on getCurrentLocation()
	global theLocation, maxSeconds, timeStarted
	set locationManager to current application's CLLocationManager's alloc()'s init()
	locationManager's requestAlwaysAuthorization()
	locationManager's setDelegate:me
	locationManager's requestLocation()
	
	repeat while theLocation is (missing value) and (current date) - timeStarted < maxSeconds
		delay 0.5
	end repeat
	
	return last item of theLocation
end getCurrentLocation

on locationManager:locationManager didUpdateLocations:locations
	global theLocation
	set theLocation to locations
end locationManager:didUpdateLocations:

on locationManager:locationManager didFailWithError:err
	error err's localizedDescription() as text
end locationManager:didFailWithError:

set myLocation to getCurrentLocation()
if myLocation is not (missing value) then
	return myLocation's coordinate()
end if
