package haxor.test;
import haxe.Timer;
import haxe.unit.Test;
import haxe.unit.Assert;
import haxor.server.ConvertService;

import js.Node;
import nws.Application;
import nws.controller.Controller;
import nws.Entity;

/**
 * ...
 * @author Eduardo Pons - eduardo@thelaborat.org
 */
class TestHolistic extends Test
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
		
		verbose = true;
	}
	
	@TestAsync("Async Request Test")
	@TestDescription("Validates if a simple request test works.","Eduardo")
	public function testRequest(a:Assert) : Void
	{
		var request = Node.require('request');		
		request('http://localhost:9090/convert/test', function (error, response, body) 
		{
			a.NotNull(response, "Response is null!");
			a.Done();		   	
		});

	}
	
	/*
	@Test("Fail 50%")
	@TestDescription("Simple dumb test 50% of failing.","Eduardo")
	public function testDumb(a:Assert) : Void
	{
		a.False(Math.random() < 0.5, "Some random error!");
	}
	
	@TestAsync("Will Timeout Test",1.0)
	@TestDescription("Forces the test to fail by timeout.","Eduardo")
	public function testTimeout(a:Assert) : Void
	{
		//Delay wait 2s but timeout is 1s
		Timer.delay(function()
		{
			a.True(true, "Not true!");
			a.Done();
		},2000);		
	}
	*/
	
	@Test("Get Temp Name")
	@TestDescription("Get some temp name.","Henrique")
	public function testGetTempName(a:Assert) : Void
	{
		a.True(convert.GetTempName().length == 24, "Temp Name Fail");		
	}

	@Test("Test the Assimp.")
	@TestDescription("I don't know!!!","Henrique")
	public function testAssimp(a:Assert) : Void
	{		
		a.True(convert.TestAssimp(true), "Test Assimp Fail");
			
	}
	
	
}