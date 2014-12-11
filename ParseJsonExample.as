package 
{
	
	/**
	 * ...
	 * @author H. Quintin Evans
	 */
	public class  
	{
		            if(ExternalInterface.available)
			{
                ExternalInterface.call("sf_register", this);
            }
            else
            {
                // Start for local debugging
                start();
				//add text field to see what values are being tested
				testingInfoDisplay = new TextField;
				testingInfoDisplay.fontColor = 0xff0000;
				testingInfoDisplay.x = 250;
				testingInfoDisplay.y = 0;				
				stage.addChild(testingInfoDisplay);
				
				//read in JSON file
				var testDataLoader:URLLoader = new URLLoader;
				var url:URLRequest = new URLRequest("testData.json");

				testDataLoader.load(url);
				
				//parse file
				testDataLoader.addEventListener(Event.COMPLETE, parseJson);
				//handle error
				testDataLoader.addEventListener(IOErrorEvent.IO_ERROR, notifyIOError);
				
				//start testing each value with a 2 second delay
				//create timer that will fire off every 2 seconds
				testingTimer = new Timer(2000);
				testingTimer.addEventListener(TimerEvent.TIMER, testDataPoint);
            }
		}		
				
		private var testData:Object;
		private var testingQueue:Vector.<Object>;
		private function parseJson(event:Event):void
		{
			//parse test data
			var loader:URLLoader = URLLoader(event.target);
			testData = JSON.parse(loader.data);
			trace(testData.toString());
			//build testing queue
			buildTestQueue(testData);
			//run test data
			testingTimer.start();
		}
		
		private function buildTestQueue(data:Object):void
		{
			for each (var object:Object in data)
			{
				testingQueue.push(object);
			}
		}
		
		private function notifyIOError(event:Event):void
		{
			trace("Error with IO");
			event.target.removeEventListener(IOErrorEvent.IO_ERROR, notifyIOError);
		}
		
		private function testDataPoint(event:TimerEvent):void
		{
			// is queue empty?
			if (testingQueue.length > 0)
			{
				//if not, see if last element still has some test points left
				if (testingQueue[testingQueue.length - 1]["testValues"].length > 0)
				{
					//if it does test the next test point
					var currentDataPoint:Object = testingQueue[testingQueue.length - 1];
					//display test parameters
					testingInfoDisplay.text = currentDataPoint["componentName"] + "  " + currentDataPoint["testValues"][currentDataPoint["testValues"].length - 1];
					//change value of component to this test point
					changeValue(currentDataPoint["componentName"], currentDataPoint["testValues"][currentDataPoint["testValues"].length - 1]);
					//remove that test point
					currentDataPoint["testValues"].pop();
				}
				else
				{
					//if it doesnt have any more test points
					//remove data point
					testingQueue.pop();
				}
			}
			else 
			{
				//stop timer
				testingTimer.stop();
			}
		}
	}
	
}