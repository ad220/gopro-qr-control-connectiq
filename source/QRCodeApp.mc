import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

using GFMath as GFM;

class QRCodeApp extends Application.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {
        GFM.initMath();
    }

    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {
    }

    // Return the initial view of your application here
    function getInitialView() as [Views] or [Views, InputDelegates] {
        return [ new QRCodeView() ];
    }

}

function getApp() as QRCodeApp {
    return Application.getApp() as QRCodeApp;
}