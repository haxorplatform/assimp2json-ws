package haxor.test;

import js.Node;
import haxor.server.ConvertService;
import haxor.server.AssimpApp;
import nws.Entity;
import nws.Application;
import nws.component.net.HttpSession;
import js.node.http.ServerResponse;

class TestBugs extends haxe.unit.TestCase
{

	var convert : ConvertService;

	override public function setup() {
		var entity : Entity = new Entity();
		entity.AddComponent(ConvertService);
		convert = cast entity.GetComponent(ConvertService);

		untyped Application.instance = cast { get_unix : function() { true; } };
		untyped convert.m_session = { };
		untyped convert.session.response = { };
		untyped convert.session.response.write = function(s) { true; };
		untyped convert.session.response.end = function() { true; };
	}


	public function testGetTempName()
	{
		assertEquals ( convert.GetTempName().length , 24 );
	}

	public function testAssimp()
	{
		assertTrue( convert.TestAssimp(true) );
	}

}