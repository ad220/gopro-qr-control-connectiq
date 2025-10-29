import Toybox.Lang;
import Toybox.Graphics;
import Toybox.WatchUi;

class QRCodeView extends WatchUi.View {

    private var qr as QRCode?;
    private var matrix as Array?;

    function initialize() {
        View.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        qr = new QRCode("https://www.qrcode.com/", 'M');
        setLayout(Rez.Layouts.MainLayout(dc));
        // Génération du QR Code "Hello World!" en version automatique
        // matrix = QRCodeGenerator.generateMatrix("Hello World!", "M");
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        // Call the parent onUpdate function to redraw the layout
        if (dc has :setAntiAlias) {
            dc.setAntiAlias(true);
        }
        View.onUpdate(dc);

        if (GFMath.GEN_POLYS.size()<29) {
            GFMath.initNextGenPoly();
            WatchUi.requestUpdate();
            return;
        } 

        var width = dc.getWidth();
        var height = dc.getHeight();
        var progress = qr.compute();
        if (progress != 1) {
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
            dc.drawRoundedRectangle(0.25*width, 0.64*height, 0.5*width, 0.06*height, 0xFF);
            dc.fillRoundedRectangle(0.26*width, 0.65*height, 0.48*width*progress, 0.04*height, 0xFF);
            WatchUi.requestUpdate();
            return;
        }
        matrix = qr.getMatrix();
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);
        dc.clear();

        var size = matrix.size();
        var pixelSize = (dc.getWidth()/Math.sqrt(2)/size - 0.1).toNumber();
        var startPos = (dc.getWidth()-(size*pixelSize))/2;
        var x;
        var y = startPos;
        for (var i=0; i<size; i++) {
            x = startPos;
            for (var j=0; j<size; j++) {
                if (matrix[i][j] != 0) {
                    dc.fillRectangle(x, y, pixelSize, pixelSize);
                }
                x += pixelSize;
            }
            y += pixelSize;
        }
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

}
