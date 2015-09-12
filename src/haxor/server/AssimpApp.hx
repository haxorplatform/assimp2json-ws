package haxor.server;

import haxor.server.ControllerContainer;
import nws.Application;
import nws.view.View;
import nws.model.Model;

class AssimpApp extends ApplicationMVC<Model,View,ControllerContainer>
{
	/**
	 * Entry point.
	 */
	static function main():Void { new AssimpApp(); }
	
	/**
	 * Entry point.
	 */
	override public function OnInitialize():Void 
	{		
		controller = cast AddComponent(ControllerContainer);		
	}	
	
}