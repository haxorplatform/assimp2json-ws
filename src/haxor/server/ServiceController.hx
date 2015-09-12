package haxor.server;

import haxor.server.AssimpService;
import haxor.server.ControllerContainer;
import nws.controller.Controller;
import nws.controller.service.Service;


/**
 * Base class for all HaxorStudio services.
 * @author Eduardo Pons - eduardo@thelaborat.org
 */
class ServiceController extends ControllerContainer
{

	/**
	 * Init.
	 */
	override public function OnInitialize():Void 
	{
		//Add services components		
		entity.AddComponent(AssimpService);

	}
	
	
}