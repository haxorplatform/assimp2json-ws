package haxor.unit;
import haxe.macro.Expr.ImportExpr;
import haxe.Timer;
import nws.component.Component;
import nws.Resource.MetaData;

/**
 * Component that when extended, implements and executes unit tests.
 * @author Eduardo Pons - eduardo@thelaborat.org
 */
class TestUnit extends Component
{

	/**
	 * List of tests.
	 */
	public var tests	: Array<MetaData>;
	
	/**
	 * Test length.
	 */
	public var length(get, never):Int;
	private function get_length():Int { return tests.length;} 
	
	/**
	 * Success Count
	 */
	public var success  : Int;
	
	/**
	 * Fail Count
	 */
	public var fail 	: Int;
	
	/**
	 * Timeout Count
	 */
	public var timeout  : Int;
	
	/**
	 * Buffer of tests to be executed.
	 */
	private var m_buffer : Array<MetaData>;
	
	/**
	 * Init.
	 */
	override public function OnCreate():Void 
	{
		success  = 0;
		fail     = 0;
		timeout  = 0;
		tests	 = [];
		m_buffer = [];
		var ml : Array<MetaData> = metadata;						
		for (m in ml) { var is_test   : Bool = (m.data.Test != null) || (m.data.TestAsync != null); if (is_test) tests.push(m); }
		Log("Initialize tests["+length+"]",1);
	}
	
	/**
	 * Callback called when testing is finished.
	 */
	private function OnTestComplete():Void { }
	
		
	/**
	 * Run All Tests.
	 * @param	p_title
	 */
	public function Run(p_title:String):Void
	{		
		success = 0;
		fail    = 0;
		timeout = 0;
		m_buffer = tests.copy();
		trace("======= " + p_title+" - "+length+" tests =======");
		UnqueueTest();
	}	
	
	/**
	 * Unqueues a test and execute it.
	 */
	private function UnqueueTest():Void
	{
		if (m_buffer.length <= 0)
		{
			OnTestComplete();
			trace("======= success["+success+"] fail["+fail+"] timeout["+timeout+"] =======");
			return;
		}
		RunTest(m_buffer.shift());
	}
	
	/**
	 * Executes a single test for a given testing metadata.
	 * @param	p_meta
	 */
	private function RunTest(p_meta:MetaData):Void
	{
		var m : MetaData = p_meta;		
		var f : String = m.field;
		var is_async  	 : Bool    			= m.data.TestAsync != null;
		var test_meta 	 : Array<Dynamic>   = is_async ? m.data.TestAsync : m.data.Test;
		var test_name 	 : String 			= test_meta[0] == null ? f  : test_meta[0];
		var test_timeout : Int	 			= test_meta[1] == null ? -1 : test_meta[1];
		var test_desc 	 : Array<String>	= m.data.TestDescription == null ? ["",""] : m.data.TestDescription;
		var desc 	  	 : String			= test_desc[0];
		
		if (test_desc[1] != "") desc += " author["+test_desc[1]+"]";
		
		var fn : Dynamic = Reflect.getProperty(this, f);
		
		trace("[start]   "+test_name+" - "+desc);
		
		if (is_async)
		{	
			var is_timeout : Bool = false;
			
			if (test_timeout >= 0)  Timer.delay(function() { is_timeout = true; }, Std.int(test_timeout * 1000));
			
			fn(function(res:String):Void
			{	
				if (is_timeout)
				{
					trace("[fail]    " + test_name+" [timeout]");
					timeout++;
					fail++;
				}
				else
				{
					if (res == "")
					{
						trace("[success] " + test_name); 
						success++;
					}
					else 
					{
						trace("[fail]    " + test_name+" [" + res + "]");					
						fail++;
					}
				}
				UnqueueTest();
			});				
		}
		else
		{	
			var res : String = fn();
			if (res == "")
			{
				trace("[success] " + test_name); 
				success++;
			}
			else
			{
				trace("[fail]    " + test_name+" [" + res + "]");
				fail++;
			}
			UnqueueTest();
		}
	}
	
}