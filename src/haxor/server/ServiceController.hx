package haxor.server;

import haxor.server.ConvertService;
import haxor.server.AssimpController;
import nws.controller.Controller;
import nws.controller.service.Service;


/**
 * Base class for all HaxorStudio services.
 * @author Eduardo Pons - eduardo@thelaborat.org
 */
class ServiceController extends Controller
{

	/**
	 * Init.
	 */
	override public function OnInitialize():Void 
	{
		//Add services components		
		entity.AddComponent(ConvertService);

	}
	
	
}