(() => {
	ObjC.import('Foundation');
	ObjC.import('Speech');
	
	var app = Application.currentApplication();
	
	if (!$['SFSpeechRecognitionTaskDelegate']) {
		ObjC.registerSubclass({
	   		name: 'SFSpeechRecognitionTaskDelegate',
	   		superclass: 'NSObject',
	   		protocols: ['SFSpeechRecognitionTaskDelegate'],
			properties: {
				spokenContent: 'id'
			},
   			methods: {
        		'speechRecognitionTask:didFinishRecognition:': {
					types: ['void', ['id', 'id']],
					implementation: function(task, result) {
		  				this.spokenContent = result.bestTranscription.formattedString.js
        			},
				}
    		}
		})
	}

	const fileURL = $.NSURL.fileURLWithPath('/Users/exampleUser/Documents/Audio 1.wav');
	
	const locale = $.NSLocale.localeWithLocaleIdentifier('en-US');
	const recognizer = $.SFSpeechRecognizer.alloc.initWithLocale(locale);
	const request = $.SFSpeechURLRecognitionRequest.alloc.initWithURL(fileURL);
	const delegate = $.SFSpeechRecognitionTaskDelegate.alloc.init
	recognizer.recognitionTaskWithRequestDelegate(request, delegate);
	
	while (delegate.spokenContent.js == undefined) {
		delay(0.1)
	}

	return delegate.spokenContent.js
})()
