import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

using GFMath as GFM;

class QRCodeApp extends Application.AppBase {

    var qrCommand as String;
    var qrParams as Dictionary;

    function initialize() {
        AppBase.initialize();

        qrCommand = "";
        qrParams = {};
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
        var menu = new Rez.Menus.QRControlMenu();
        return [ menu, new LabsMenuDelegate(menu) ];
    }

    function setParam(key as String, value as String) {
        var prevParam = qrParams.get(key) as String?;
        if (prevParam == null) {
            if (!value.equals("")) {
                qrParams.put(key, value);
                qrCommand = qrCommand + value;
            }
        } else {
            var index = qrCommand.find(prevParam);
            qrCommand = qrCommand.substring(null, index) + value 
                + qrCommand.substring(index + prevParam.length(), null);
            if (value.equals("")) {
                qrParams.remove(key);
            } else {
                qrParams.put(key, value);
            }
        }
    }
}

function getApp() as QRCodeApp {
    return Application.getApp() as QRCodeApp;
}