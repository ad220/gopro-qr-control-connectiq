import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

using GFMath as GFM;

class QRControlApp extends Application.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {
        AppSettings.init();
        GFM.initMath();
    }

    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {
    }

    function getInitialView() as [Views] or [Views, InputDelegates] {
        if (System.DeviceSettings has :isGlanceModeEnabled and System.getDeviceSettings().isGlanceModeEnabled) {
            return getHomeMenu();
        } else {
            return [ new TitleScreen(), new TitleDelegate() ];
        }
    }

    // Return the initial view of your application here
    function getHomeMenu() as [Views, InputDelegates] {
        var menu = new WatchUi.Menu2({:title => Rez.Strings.AppName});
        return [ menu, new MainMenuDelegate(menu) ];
    }

    function returnHome() {
        var view = getHomeMenu() as Array;
        WatchUi.switchToView(view[0], view[1], WatchUi.SLIDE_RIGHT);
    }
}

function getApp() as QRControlApp {
    return Application.getApp() as QRControlApp;
}