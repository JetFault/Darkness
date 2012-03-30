package  
{
	/**
	 * ...
	 * @author Darkness Team
	 */
	public class Constants 
	{
	
		//Enemy run speed?
		//DFS Depth?
		//Will putting embedded files in here work?
		
		//Lightning variables
		public static var cameralightningdiff:Number = .3; //in [0,1].  originally 1
		public static var lightningcolor:uint = 0x00d5d7ff; //0x00ffffff 0x00b5b7ff
		public static var looptime:Number = 5;
		public static var flashduration:Number = 1.5;
		public static var crashtime:Number = .01;
		public static var rumbletime:Number = 1.5;
		public static var soundthreshold:Number = 100;
		public static var functiontype:String = "batch"; //From ["batch", "sequential"]  Former generates array, latter generates samples on fly
		public static var flashfunctionsequential:Function = Utils.sampleradialdecrease; //Functions in Utils.as.  Just insert function name here.  All univariate
		public static var flashfunctionbatch:Function = Utils.brownian;
		public static var periodic:Boolean = true;
		//Player variables
		public static var controlScheme:int  = 2;
		
		
		//Spotlight variables
		public static var scalelight:Boolean = false;
		public static var raytracelight:Boolean = false;
		
		
	}

}