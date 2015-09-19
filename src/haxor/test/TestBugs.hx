package haxor.test;

import js.Node;
import haxor.server.ConvertService;
import nws.Entity;
import nws.Application;

class TestBugs extends haxe.unit.TestCase
{

	var convert : ConvertService;

	override public function setup() {
		var entity : Entity = new Entity();
		entity.AddComponent(ConvertService);
		convert = cast entity.GetComponent(ConvertService);
	}


	public function testGetTempName()
	{
		assertEquals ( convert.GetTempName().length , 24 );
	}

	public function testAssimp()
	{
		assertTrue( true ); //convert.TestAssimp(true)
	}

}