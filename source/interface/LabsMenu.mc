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
                menu = data.command.equals("") ? new ConfirmView(Rez.Strings.ConfirmNull) : new QRCodeView(data);
            }
        }
        else if (firstItemId == :resolution) {
            // Sorting codes start at 0x00, 0x10 for future proof and capture mode
            if      (id==:resolution)   { menu = new Rez.Menus.ResolutionPicker();      key = "x10res"; }
            else if (id==:framerate)    { menu = new Rez.Menus.FrameratePicker();       key = "x14fr"; }
            else if (id==:lens)         { menu = new Rez.Menus.LensPicker();            key = "x18lens"; }
            else if (id==:hypersmooth)  { menu = new Rez.Menus.HypersmoothPicker();     key = "x1Beis"; }
            else if (id==:hindsight)    { menu = new Rez.Menus.HindsightPicker();       key = "x20hs"; }
        }
        else if (firstItemId == :audio) {
            // Sorting codes start at 0x40, 0x50 for future proof
            if      (id==:audio)        { menu = new Rez.Menus.AudioPicker();           key = "x50raw"; }
            else if (id==:bitrate)      { menu = new Rez.Menus.BitratePicker();         key = "x54br"; }
            else if (id==:bitdepth)     { menu = new Rez.Menus.BitdepthPicker();        key = "x58bd"; }
            else if (id==:whitebalance) { menu = new Rez.Menus.WBPicker();              key = "x5Bwb"; }
            else if (id==:color)        { menu = new Rez.Menus.ColorPicker();           key = "x60cp"; }
            else if (id==:sharpness)    { menu = new Rez.Menus.SharpnessPicker();       key = "x64sharp"; }
            else if (id==:evcomp)       { menu = new Rez.Menus.EVCompPicker();          key = "x68evc"; }
            else if (id==:evlock)       { menu = new Rez.Menus.EVLockPicker();          key = "x6Bevl"; }
            else if (id==:shutterangle) { menu = new Rez.Menus.ShutterAnglePicker();    key = "x72sa"; }
            else if (id==:isomin)       {
                menu = new Rez.Menus.ISOPicker();
                menu.setTitle(Rez.Strings.ISOMin);
                key = "x71isom";
            }
            else if (id==:isomax)       {
                menu = new Rez.Menus.ISOPicker();
                menu.setTitle(Rez.Strings.ISOMax);
                key = "x70isoM";
            }
        }
        else if (firstItemId == :camera) {
            if      (id==:camera)       { menu = new Rez.Menus.XCCameraPicker(); }
            else if (id==:video)        { menu = new Rez.Menus.XCVideoPicker(); }
            else if (id==:audio)        { menu = new Rez.Menus.XCAudioPicker(); }
            else if (id==:labs)         { menu = new Rez.Menus.XCLabsPicker(); }
            else if (id==:reset)        {
                data.command = "!RESET" + data.command;
                data.params.put("RESET", "!RESET");
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
            if (data.command.equals("")) {
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