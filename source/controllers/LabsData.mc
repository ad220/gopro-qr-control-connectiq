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
        var paramCode = key.substring(1,3);
        key = "707172".find(paramCode) == null ? key : "$73iso";
        var prevParam = params.get(key) as String?;

        if (key.equals("$73iso")) {
            // ISO HELLL !!!
            prevParam = params.get(key) as String?;
            var saIdx = prevParam != null ? prevParam.find("S") : null; 
            var minIdx = prevParam != null ? prevParam.find("M") : null;

            var max = "64";
            if (paramCode.equals("70")) {
                max = value.length() ? value : max;
            } else if (prevParam != null) {
                max = prevParam.substring(1, minIdx != null ? minIdx : (saIdx != null ? saIdx : prevParam.length()));
            }

            var min = null;
            if (paramCode.equals("71")) {
                min = value.length() ? value : null;
            } else if (prevParam != null and minIdx != null) {
                min = prevParam.substring(minIdx+1, (saIdx != null ? saIdx : prevParam.length()));
            }
            
            var angle = null;
            if (paramCode.equals("72")) {
                angle = value.length() ? value : null;
            } else if (prevParam != null and saIdx != null) {
                angle = prevParam.substring(saIdx+1, prevParam.length());
            }

            value = "i"+max;
            if (min != null)    { value += "M"+min; }
            if (angle != null)  { value += "S"+angle; }

            if (value.equals("i64")) { value = ""; }
            System.println(value);
        }

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