package haxor.test;
import haxe.Timer;
import haxor.server.ConvertService;
import haxor.unit.TestUnit;
import js.Node;
import nws.Application;
import nws.controller.Controller;
import nws.Entity;

/**
 * ...
 * @author Eduardo Pons - eduardo@thelaborat.org
 */
class TestHaxor extends TestUnit
{

	public var convert : ConvertService;

	
	/**
	 * Init.
	 */
	override private function OnTestCreate():Void 
	{
		trace("TestHaxor> Create!");
		var entity : Entity = new Entity();
		entity.AddComponent(ConvertService);
		convert = cast entity.GetComponent(ConvertService);

		untyped Application.instance = cast { get_unix : function() { true; } };
		untyped convert.m_session = { };
		untyped convert.session.response = { };
		untyped convert.session.response.write = function(s) { true; };
		untyped convert.session.response.end = function() { true; };
	}
	
	@TestAsync("Async Request Test")
	@TestDescription("Validates if a simple request test works.","Eduardo")
	public function testRequest(p_callback:String->Void) : Void
	{
		Timer.delay(function()
		{
			var success :Bool = false;
			var err : String = "";			
			if (!success) err = "We found error :(";			
			p_callback(err);			
		},Std.int(500 + (Math.random() * 2000)));
	}
	
	@Test("Fail 50%")
	@TestDescription("Simple dumb test 50% of failing.","Eduardo")
	public function testDumb() : String
	{
		return Math.random() < 0.5 ? "Some random error!" : "";
	}
	
	@TestAsync("Will Timeout Test",1.0)
	@TestDescription("Forces the test to fail by timeout.","Eduardo")
	public function testTimeout(p_callback:String->Void) : Void
	{
		//Delay wait 2s but timeout is 1s
		Timer.delay(function()
		{
			var success :Bool = true;
			var err : String = "";			
			if (!success) err = "We found error :(";			
			p_callback(err);			
		},2000);		
	}
	
	@Test("Get Temp Name")
	@TestDescription("Get some temp name.","Henrique")
	public function testGetTempName() : String
	{
		if (convert.GetTempName().length == 24) return "";
		return "wrong size!";
	}

	@Test("Test the Assimp.")
	@TestDescription("I don't know!!!","Henrique")
	public function testAssimp() : String
	{		
		if (convert.TestAssimp(true)) return "";
		return "something is wrong";		
	}
	
	
}