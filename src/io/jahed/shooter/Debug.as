package io.jahed.shooter {
	
	public class Debug {
		public static function timeTrace(message:String):void {
			var date:Date = new Date();
			
			trace("[" + date.toLocaleTimeString() + "] - " + message);
		}
	}

}