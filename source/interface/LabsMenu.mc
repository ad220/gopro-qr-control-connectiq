import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class LabsMenuDelegate extends Menu2InputDelegate {

    private var menu as Menu2;
    private var data as LabsData;
    private var firstItemId as Symbol;

    public function initialize(menu as Menu2, data as LabsData) {
        Menu2InputDelegate.initialize();

        self.menu = menu;
        self.data = data;
        firstItemId = menu.getItem(0).getId() as Symbol;
    }

    public function onSelect(item as MenuItem) as Void {
        var menu = null;
        var key = "";
        var id = item.getId();
        if      (firstItemId == :video) {
            if      (id==:video)        { menu = new Rez.Menus.VideoSettings(); }
            else if (id==:protune)      { menu = new Rez.Menus.ProtuneSettings(); }
            else if (id==:extended)     { menu = new Rez.Menus.ExtendedControls(); }
            else if (id==:generate)     {
                if (data.command.equals("")) {
                    menu = new ConfirmView(Rez.Strings.ConfirmNull);
                } else if (data.command.length() > (AppSettings.get("force_qr_v1") ? 19 : 34)) {
                    menu = new ConfirmView(Rez.Strings.ConfirmLong);
                } else {
                    if (AppSettings.get("auto_order") and Array has :sort) {
                        data.command = "";
                        var keys = data.params.keys();
                        keys.sort(null);
                        for (var i=0; i<keys.size(); i++) {
                            data.command += data.params.get(keys[i]);
                        }
                    }

                    menu = new QRCodeView(data);
                }
            }
        }
        else if (firstItemId == :resolution) {
            // Sorting codes start at 0x00, 0x10 for future proof and capture mode
            if      (id==:resolution)   { menu = new Rez.Menus.ResolutionPicker();      key = "$10res"; }
            else if (id==:framerate)    { menu = new Rez.Menus.FrameratePicker();       key = "$14fr"; }
            else if (id==:lens)         { menu = new Rez.Menus.LensPicker();            key = "$18lens"; }
            else if (id==:hypersmooth)  { menu = new Rez.Menus.HypersmoothPicker();     key = "$1Beis"; }
            else if (id==:hindsight)    { menu = new Rez.Menus.HindsightPicker();       key = "$20hs"; }
        }
        else if (firstItemId == :audio) {
            // Sorting codes start at 0x40, 0x50 for future proof
            if      (id==:audio)        { menu = new Rez.Menus.AudioPicker();           key = "$50raw"; }
            else if (id==:bitrate)      { menu = new Rez.Menus.BitratePicker();         key = "$54br"; }
            else if (id==:bitdepth)     { menu = new Rez.Menus.BitdepthPicker();        key = "$58bd"; }
            else if (id==:whitebalance) { menu = new Rez.Menus.WBPicker();              key = "$5Bwb"; }
            else if (id==:color)        { menu = new Rez.Menus.ColorPicker();           key = "$60cp"; }
            else if (id==:sharpness)    { menu = new Rez.Menus.SharpnessPicker();       key = "$64sharp"; }
            else if (id==:evcomp)       { menu = new Rez.Menus.EVCompPicker();          key = "$68evc"; }
            else if (id==:evlock)       { menu = new Rez.Menus.EVLockPicker();          key = "$6Bevl"; }
            else if (id==:shutterangle) { menu = new Rez.Menus.ShutterAnglePicker();    key = "$72sa"; }
            else if (id==:isomin)       {
                menu = new Rez.Menus.ISOPicker();
                menu.setTitle(Rez.Strings.ISOMin);
                key = "$71isom";
            }
            else if (id==:isomax)       {
                menu = new Rez.Menus.ISOPicker();
                menu.setTitle(Rez.Strings.ISOMax);
                key = "$70isoM";
            }
        }
        else if (firstItemId == :camera) {
            if      (id==:camera)       { menu = new Rez.Menus.XCCameraPicker(); }
            else if (id==:video)        { menu = new Rez.Menus.XCVideoPicker(); }
            else if (id==:audio)        { menu = new Rez.Menus.XCAudioPicker(); }
            else if (id==:labs)         { menu = new Rez.Menus.XCLabsPicker(); }
            else if (id==:reset)        {
                data.command = "!RESET" + data.command;
                data.params.put("!RESET", "!RESET");
                onBack();
                return;
            }
        } 

        if (menu instanceof Menu2) {
            var delegate = firstItemId == :video
                ? new LabsMenuDelegate(menu, data)
                : new LabsPickerDelegate(menu, data, key, firstItemId, self.menu.findItemById(id));
            WatchUi.switchToView(menu, delegate, SLIDE_LEFT);
        } else {
            if (menu instanceof ConfirmView) {
                pushView(menu, new ConfirmDelegate(null), SLIDE_UP);
            } else {
                switchToView(menu, new QRCodeDelegate(menu), SLIDE_LEFT);
            }
        }
    }

    public function onBack() as Void {
        if (firstItemId != :video) {
            var menu = new Rez.Menus.LabsMenu();
            var focus = -1;
            if      (firstItemId == :resolution)    { focus = 0; }
            else if (firstItemId == :audio)         { focus = 1; }
            else if (firstItemId == :camera)        { focus = 2; }
            menu.setFocus(focus);
            WatchUi.switchToView(menu, new LabsMenuDelegate(menu, data), SLIDE_RIGHT);
        } else {
            pushView(
                new ConfirmView(Rez.Strings.ConfirmBack),
                new ConfirmDelegate(method(:cancel)),
                SLIDE_DOWN
            );
        }
    }

    public function cancel() as Void {
        getApp().returnHome();
    }
}