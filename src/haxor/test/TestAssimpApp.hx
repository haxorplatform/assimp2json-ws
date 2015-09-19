package haxor.test;
import haxe.Timer;
import haxor.server.AssimpApp;
import nws.Resource.MetaData;

/**
 * ...
 * @author Eduardo Pons - eduardo@thelaborat.org
 */
class TestAssimpApp extends AssimpApp
{

	/**
	 * Entry point.
	 */
	static function main():Void { new TestAssimpApp(); }
	
	/**
	 * Reference to the test container.
	 */
	public var test : TestController;
	
	/**
	 * Init.
	 */
	override public function OnInitialize():Void 
	{
		Log("Application Testing Suit");
		super.OnInitialize();
		
		test = cast CreateChild("test", TestController);
		
		Timer.delay(Run, 100);
	}
	
	public function Run():Void
	{		
		
		var ml : Array<MetaData> = test.metadata;		
		var c  : Int = 0;
		for (m in ml) { var is_test   : Bool = (m.data.Test != null) || (m.data.TestAsync != null); if (is_test) c++; }
		trace(" ");
		trace("Running Suit - "+c+" tests.");
		for (m in ml)
		{
			RunTest(test, m);
		}
	}
	
	public function RunTest(p_target:Dynamic, p_meta:MetaData):Void
	{
		var m : MetaData = p_meta;
		
		var is_test   : Bool = (m.data.Test != null) || (m.data.TestAsync != null);
		if (!is_test) return;
		var f : String = m.field;
		var is_async  : Bool    		= m.data.TestAsync != null;
		var test_meta : Array<Dynamic>  = is_async ? m.data.TestAsync : m.data.Test;
		var test_name : String 			= test_meta[0] == null ? f : test_meta[0];
		var test_desc : Array<String>	= m.data.TestDescription == null ? ["",""] : m.data.TestDescription;
		var desc 	  : String			= test_desc[0];
		
		if (test_desc[1] != "") desc += " author["+test_desc[1]+"]";
		
		var fn : Dynamic 				= Reflect.getProperty(p_target, f);
		
		trace("[start ] ["+test_name+"] async["+is_async+"] "+desc);
		
		if (is_async)
		{
			
			fn(function(res:String):Void
			{	
				if (res == "") trace("[finish] [success] ["+test_name+"]"); else trace("[finish] [fail] ["+test_name+"]["+res+"]");
			});				
		}
		else
		{			
			var fn : Void->String = Reflect.getProperty(test, f);
			var res : String = fn();
			if (res == "") trace("[finish] [success] ["+test_name+"]"); else trace("[finish] [fail] ["+test_name+"]["+res+"]");
		}
	}
	
}