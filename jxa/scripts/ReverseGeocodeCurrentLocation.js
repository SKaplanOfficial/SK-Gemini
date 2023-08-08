(() => {
	ObjC.import('CoreLocation')
	app = Application.currentApplication()
	app.includeStandardAdditions = true

	if (!$['CLLocationManagerDelegate']) {
		ObjC.registerSubclass({
			name: 'CLLocationManagerDelegate',
			superclass: 'NSObject',
			protocols: ['CLLocationManagerDelegate'],
			properties: {
				locations: 'id'
			},
			methods: {
				'locationManager:didUpdateLocations:': {
					types: ['void', ['id', 'id']],
					implementation: function (lm, locs) {
						this.locations = locs
						return;
					},
				},
				'locationManager:didFailWithError:': {
					types: ['void', ['id', 'id']],
					implementation: function (lm, error) {
						locations = []
						app.displayAlert(error.localizedDescription.js)
						return;
					}
				}
			}
		})
	}

	lm = $.CLLocationManager.alloc.init
	lm.requestAlwaysAuthorization
	delegate = $.CLLocationManagerDelegate.alloc.init;
	lm.delegate = delegate
	lm.requestLocation

	while (delegate.locations.js == undefined) {
		runLoop = $.NSRunLoop.currentRunLoop
		today = $.NSDate.dateWithTimeIntervalSinceNow(0.1)
		runLoop.runUntilDate(today)
	}

	geocoder = $.CLGeocoder.alloc.init
	placemarks = null

	geocoder.reverseGeocodeLocationCompletionHandler(delegate.locations.objectAtIndex(0), (p, e) => {
		placemarks = p
	})

	while (placemarks == null) {
		runLoop = $.NSRunLoop.currentRunLoop
		today = $.NSDate.dateWithTimeIntervalSinceNow(0.1)
		runLoop.runUntilDate(today)
	}

	placemark = placemarks.objectAtIndex(0)

	placeName = placemark.name.js
	placeStreetNum = placemark.subThoroughfare.js
	placeStreet = placemark.thoroughfare.js
	placeCity = placemark.locality.js
	placeState = placemark.administrativeArea.js
	placePostal = placemark.postalCode.js
	placeCountry = placemark.country.js

	return `${placeName}: ${placeStreetNum} ${placeStreet}, ${placeCity}, ${placeState} ${placePostal}, 
${placeCountry}`
})()
