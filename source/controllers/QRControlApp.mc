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

    // Return the initial view of your application here
    function getInitialView() as [Views] or [Views, InputDelegates] {
        var menu = new WatchUi.Menu2({:title => Rez.Strings.AppName});
        return [ menu, new MainMenuDelegate(menu) ];
    }
}

function getApp() as QRControlApp {
    return Application.getApp() as QRControlApp;
}