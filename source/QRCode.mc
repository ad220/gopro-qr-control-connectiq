import Toybox.System;
import Toybox.Lang;
import Toybox.Math;

using GFMath as GFM;

class QRCode {

    typedef QRMatrix as Array<ByteArray>;

    private const AVAILABLE_MODULES = [26, 44];
    private const VERSION_TABLE = {
        'L' => [19,34],
        'M' => [16,28],
        'Q' => [13,22],
        'H' => [9,16],
    };
    private const PROCESSING_STEPS = 10;

    private var data as String;
    private var ecc as Char;
    private var size as Number;
    private var version as Number;
    private var processState as Number;
    private var maskIndex as Number;
    private var penaltyScore as Number;
    private var codewords as ByteArray?;
    private var codeMatrix as QRMatrix?;

// TODO: auto-ecc
    public function initialize(data as String, ecc as Char, pregenMatrix as Array<ByteArray>?) {
        self.data = data;
        self.ecc = ecc;
        self.codeMatrix = pregenMatrix;
        self.version = 0;
        self.processState = 0;
        self.maskIndex = 0;
        self.penaltyScore = 0;
        
        if (pregenMatrix == null) {
            var maxDataSizes = VERSION_TABLE.get(ecc) as Array;
            while(version<maxDataSizes.size() and maxDataSizes[version]<data.length()+2) {version++;}
            if (version == maxDataSizes.size()) {
                System.println("Input string too large");
            }
            self.size = 21 + 4*version;
        } else {
            self.size = codeMatrix.size();
            self.processState = PROCESSING_STEPS;
        }
    }

    public function compute() as Numeric {
        if (isReady()) {
            return 1;
        }

        if (processState == 0) {
            makeCodewords();
        } else if (processState == 1) {
            makeBaseMatrix();
        } else if (processState < 9) {
            findBestMask();
        } else {
            applyMask(codeMatrix, maskIndex);
            placePatterns(codeMatrix);
            placeErrorMaskInfo(codeMatrix);
        }
        processState++;
        return processState.toFloat()/PROCESSING_STEPS;
    }

    public function isReady() as Boolean {
        return processState == PROCESSING_STEPS;
    }

    public function getMatrix() as QRMatrix {
        return codeMatrix;
    }
    
    private function makeCodewords() as Void {
        // String to bytes with mode(4)-length(8)-data(*) format
        var bytes = data.toCharArray();
        codewords = [64 + (bytes.size()&0xF0 >> 4), bytes.size()&0x0F << 4]b;

        for (var i=0; i<bytes.size(); i++) {
            codewords[i+1] += bytes[i].toNumber() & 0xF0 >> 4;
            codewords.add(bytes[i].toNumber() & 0x0F << 4);
        }

        while (codewords.size()<(VERSION_TABLE.get(ecc) as Array)[version]) {
            codewords.add(codewords.size() & 1 ? 236 : 17);
        }
        
        // Compute and append EDC
        var msgPoly = codewords.slice(null, null);
        var totalLength = AVAILABLE_MODULES[version];
        while (msgPoly.size()<totalLength) {msgPoly.add(0);}
        codewords.addAll(GFM.polyRest(msgPoly, GFM.GEN_POLYS[totalLength - codewords.size()]));
    }

    private function makeBaseMatrix() as Void {
        codeMatrix = [];
        for (var i=0; i<size; i++) {
            codeMatrix.add([]b);
            for (var j=0; j<size; j++) { codeMatrix[i].add(0); }
        }

        reserveModules(codeMatrix);
        placeCodewords(codeMatrix);
    }

    private function reserveModules(matrix as QRMatrix) {
        fillRectangle(matrix, 0, 0, 9, 9, 1);
        fillRectangle(matrix, 0, size-8, 9, size, 1);
        fillRectangle(matrix, size-8, 0, size, 9, 1);

        fillRectangle(matrix, 9, 6, size-8, 7, 1);
        fillRectangle(matrix, 6, 9, 7, size-8, 1);

        if (version==1) {fillRectangle(matrix, size-9, size-9, size-4, size-4, 1);}
        return matrix;
    }

    private function fillRectangle(matrix as QRMatrix, xa, ya, xb, yb, value) {
        for (var i=xa; i<xb; i++) {
            for (var j=ya; j<yb; j++) {
                matrix[i][j] = value;
            }
        }
    }

    private function placeCodewords(matrix as QRMatrix) {
        var rowStep = -1;
        var row = matrix.size() - 1;
        var column = row;
        var index = 0;
        var dataIndex = 0;
        while (column >= 0) {
            if (matrix[row][column] == 0 and dataIndex < codewords.size()<<3) {
                matrix[row][column] = (codewords[dataIndex/8] & (0x80>>(dataIndex%8))!=0 ? 1 : 0);
                dataIndex++;
            }
            
            if (index & 1) {
                row += rowStep;
                if (row == -1 || row == size) {
                    rowStep = -rowStep;
                    row += rowStep;
                    column -= column == 7 ? 2 : 1;
                } else {
                    column++;
                }
            } else {
                column--;
            }
            index++;
        }
    }

    private function copyMatrix(matrix as QRMatrix) as QRMatrix {
        var copy = [];
        for (var k=0; k<matrix.size(); k++) {
            copy.add(matrix[k].slice(null, null));
        }
        return copy;
    }

    private function placeFinderPattern(matrix as QRMatrix, x, y) {
        var finder = [
            [1,1,1,1,1,1,1]b,
            [1,0,0,0,0,0,1]b,
            [1,0,1,1,1,0,1]b,
            [1,0,1,1,1,0,1]b,
            [1,0,1,1,1,0,1]b,
            [1,0,0,0,0,0,1]b,
            [1,1,1,1,1,1,1]b,
        ];
        for (var i=0; i<7; i++) {
            for (var j=0; j<7; j++) {
                matrix[x+i][y+j] = finder[i][j];
            }
        }
    }

    private function placeAlignmentPattern(matrix as QRMatrix, x, y) {
        var finder = [
            [1,1,1,1,1]b,
            [1,0,0,0,1]b,
            [1,0,1,0,1]b,
            [1,0,0,0,1]b,
            [1,1,1,1,1]b,
        ];
        for (var i=0; i<5; i++) {
            for (var j=0; j<5; j++) {
                matrix[x+i][y+j] = finder[i][j];
            }
        }
    }

    private function placeErrorMaskInfo(matrix as QRMatrix) {
        var EDC_ORDER = "MLHQ";
        var FORMAT_DIVISOR = [1, 0, 1, 0, 0, 1, 1, 0, 1, 1, 1]b;
        var FORMAT_MASK = [1, 0, 1, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0]b;

        var formatPoly = []b;
        var errorLevelIndex = EDC_ORDER.find(ecc.toString());
        formatPoly.add(errorLevelIndex >> 1);
        formatPoly.add(errorLevelIndex & 1);
        formatPoly.add(maskIndex >> 2);
        formatPoly.add((maskIndex >> 1) & 1);
        formatPoly.add(maskIndex & 1);

        while (formatPoly.size()<15) { formatPoly.add(0); }
        var rest = GFM.polyRest(formatPoly, FORMAT_DIVISOR);
        formatPoly = formatPoly.slice(null, 5).addAll(rest);
        
        for (var k=0; k<15; k++) {
            formatPoly[k] ^= FORMAT_MASK[k];
        }

        matrix[8] = formatPoly.slice(0,6).add(1)
                        .addAll(formatPoly.slice(6,8))
                        .addAll(matrix[8].slice(9, size-8))
                        .addAll(formatPoly.slice(7, null));
        for (var k=0; k<7; k++) {
            matrix[size-1-k][8] = formatPoly[k];
        }
        matrix[7][8] = formatPoly[8];
        for (var k=9; k<15; k++) {
            matrix[14-k][8] = formatPoly[k];
        }
    }

    private function placePatterns(matrix) {
        fillRectangle(matrix, 0, 7, 9, 9, 0);
        fillRectangle(matrix, 7, 0, 9, 7, 0);
        fillRectangle(matrix, size-8, 0, size-7, 8, 0);
        fillRectangle(matrix, size-7, 7, size, 8, 0);
        fillRectangle(matrix, 0, size-8, 8, size-7, 0);
        fillRectangle(matrix, 7, size-7, 8, size, 0);
        placeFinderPattern(matrix, 0, 0);
        placeFinderPattern(matrix, 0, size-7);
        placeFinderPattern(matrix, size-7, 0);
        if (version) {
            placeAlignmentPattern(matrix, size-9, size-9);
        }
        for (var x=8; x<size-8; x++) {matrix[x][6] = x & 1 ^ 1;}
        for (var y=8; y<size-8; y++) {matrix[6][y] = y & 1 ^ 1;}
        matrix[size-8][8] = 1;
    }

    public function mask0(row, column) as Number {
        return (row + column + 1) & 1;
    }

    public function mask1(row, column) as Number {
        return row & 1 ^ 1;
    }

    public function mask2(row, column) as Number {
        return column % 3 ? 0 : 1;
    }

    public function mask3(row, column) as Number {
        return (row+column) % 3 ? 0 : 1;
    }
    
    public function mask4(row, column) as Number {
        return (row/2 + column/3) % 2 ? 0 : 1;
    }

    public function mask5(row, column) as Number {
        return row*column%2 + row*column%3 ? 0 : 1;
    }
    
    public function mask6(row, column) as Number {
        return ((row*column)%2 + row*column%3) % 2 ? 0 : 1;
    }
    
    public function mask7(row, column) as Number {
        return ((row+column)%2 + row*column%3) % 2 ? 0 : 1;
    }

    private function applyMask(matrix as QRMatrix, mask as Number) {
        var maskFunction = method([:mask0, :mask1, :mask2, :mask3, :mask4, :mask5, :mask6, :mask7][mask]);
        for (var i=0; i<size; i++) {
            for (var j=0; j<size; j++) {
                matrix[i][j] ^= maskFunction.invoke(i, j);
            }
        }
    }

    private function findBestMask() as Void {
        var copy = copyMatrix(codeMatrix);
        applyMask(copy, (processState-2)%8);
        placePatterns(copy);
        var penalty = getTotalPenalty(copy);
        if (penalty < self.penaltyScore or processState-2==0) {
            self.penaltyScore = penalty;
            self.maskIndex = (processState-2)%8;
        }

    }

    private function getLinePenalty(matrix as QRMatrix, index as Number, isRow as Boolean) as Number {
        var count = 0;
        var counting = 0;
        var penalty = 0;
        for (var i=0; i<size; i++) {
            if (counting != (isRow ? matrix[index][i] : matrix[i][index])) {
                counting ^= 1;
                count = 1;
            } else {
                count++;
                if (count == 5) {
                    penalty += 3;
                } else if (count > 5) {
                    penalty++;
                }
            }
        }
        return penalty;
    }

    private function getBlocPenalty(matrix as QRMatrix) as Number {
        var penalty = 0;
        for (var row = 0; row<size-1; row++) {
            for (var column=0; column<size-1; column++) {
                var pixel = matrix[row][column];
                if (
                    matrix[row][column + 1] == pixel and
                    matrix[row + 1][column] == pixel and
                    matrix[row + 1][column + 1] == pixel
                ) {
                    penalty+=3;
                }
            }
        }
        return penalty;
    }

    private function getFinderPenalty(matrix as QRMatrix, index as Number, isRow as Boolean) as Number {
        var finderPattern = [1, 0, 1, 1, 1, 0, 1, 0, 0, 0, 0]b;
        var reversePattern = finderPattern.reverse();
        var penalty = 0;

        var slice = []b;
        for (var i=0; i<11; i++) {
            slice.add(isRow ? matrix[index][i] : matrix[i][index]);
        }

        for (var i=11; i<size; i++) {
            if (slice.equals(finderPattern) or slice.equals(reversePattern)) {
                penalty+=40;
            }
            slice = slice.slice(1, null).add(isRow ? matrix[index][i] : matrix[i][index]);
        }

        return penalty;
    }


    private function getRatioPenalty(matrix as QRMatrix) as Number {
        var totalModules = size * size;
        var darkModules = 0;
        for (var i=0; i<size; i++) {
            for (var j=0; j<size; j++) {
                darkModules += matrix[i][j];
            }
        }
        var percentage = darkModules * 100.0 / totalModules;
        var diff = percentage > 50 ? (percentage/5 - 10).toNumber() : (10 - percentage/5).toNumber();
        return 10*diff;
    }

    private function getTotalPenalty(matrix as QRMatrix) as Number {
        var penalty = 0;

        for (var i=0; i<size; i++) {
            penalty += getLinePenalty(matrix, i, true);
            penalty += getFinderPenalty(matrix, i, true);
        }

        for (var j=0; j<size; j++) {
            penalty += getLinePenalty(matrix, j, false);
            penalty += getFinderPenalty(matrix, j, false);
        }
        
        penalty += getBlocPenalty(matrix);
        penalty += getRatioPenalty(matrix);

        return penalty;
    }
}