import Toybox.Lang;
import Toybox.System;
import Toybox.Application;

class LabsData {

    public var command as String;
    public var params as Dictionary;
    public var matrix as Array<ByteArray>?;

    public function initialize(command as String?) {
        if (command != null) {
            self.command = command;
            self.params = Application.Storage.getValue("paramsOf:"+command);
            self.matrix = [];

            var serializedMatrix = Application.Storage.getValue("matrixOf:"+command) as ByteArray;
            var size = serializedMatrix.size()<625 ? 21 : 25;
            for (var i=0; i<size; i++) {
                matrix.add(serializedMatrix.slice(i*size, (i+1)*size));
            }
        } else {
            self.command = "";
            self.params = {};
            self.matrix = null;
        }
    }

    
    function setParam(key as String, value as String) {
        var prevParam = params.get(key) as String?;
        if (prevParam == null) {
            if (!value.equals("")) {
                params.put(key, value);
                command = command + value;
            }
        } else {
            var index = command.find(prevParam);
            command = command.substring(0, index) + value 
                + command.substring(index + prevParam.length(), command.length());
            if (value.equals("")) {
                params.remove(key);
            } else {
                params.put(key, value);
            }
        }
    }

    function save() {
        var qrcodes = Application.Storage.getValue("qrcodes") as Array;
        if (qrcodes.indexOf(command) == -1) {
            qrcodes.add(command);
        }

        var serializedMatrix = []b;
        for (var i=0; i<matrix.size(); i++) {
            serializedMatrix.addAll(matrix[i]);
        }

        Application.Storage.setValue("qrcodes", qrcodes);
        Application.Storage.setValue("paramsOf:"+command, params);
        Application.Storage.setValue("matrixOf:"+command, serializedMatrix);
    }

    function discard() {
        var qrcodes = Application.Storage.getValue("qrcodes") as Array;
        qrcodes.remove(command);

        Application.Storage.setValue("qrcodes", qrcodes);
        Application.Storage.deleteValue("paramsOf:"+command);
        Application.Storage.deleteValue("matrixOf:"+command);
    }
}