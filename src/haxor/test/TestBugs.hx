package haxor.test;

import js.Node;
import haxor.server.ServiceController;

class TestBugs extends haxe.unit.TestCase
{

	public function testAssimp()
	{
		var assimp = ServiceController;
		var macroBlob = haxe.Json.parse("{}");
		var nonMacroBlob :Dynamic = {};
		assertTrue(haxe.Json.stringify(macroBlob) == haxe.Json.stringify(nonMacroBlob));
	}

}