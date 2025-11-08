import Toybox.Lang;

module GFMath {
    const LOG = []b;
    const EXP = []b;
    const GEN_POLYS = [[1]b];
    
    function initMath() as Void {
        // Init tables
        for (var i=0; i<256; i++) {
            LOG.add(0);
            EXP.add(0);
        }

        var value = 1;
        for (var e=1; e<256; e++) {
            value = value > 127 ? (value<<1)^285 : value<<1;
            LOG[value] = e%255;
            EXP[e%255] = value;
        }
    }

    function initNextGenPoly() as Void {
        var deg = GEN_POLYS.size();
        GEN_POLYS.add(polyMul(GEN_POLYS[deg-1], [1, EXP[deg-1]]b));
    }

    function mul(a, b) {
        return a!=0 && b!=0 ? EXP[(LOG[a] + LOG[b]) % 255] : 0;
    }

    function div(a, b) {
        return EXP[(LOG[a] + LOG[b] * 254) % 255];
    }

    function polyMul(polyA as ByteArray, polyB as ByteArray) as ByteArray {
        var coeffs = []b;
        for (var i=0; i<polyA.size()+polyB.size()-1; i++) {
            coeffs.add(0);
            for (var j=0; j<=i; j++) {
                if (j<polyA.size() and i-j<polyB.size()) {
                    coeffs[i] ^= mul(polyA[j], polyB[i-j]);
                }
            }
        }
        return coeffs;
    }

    function polyRest(dividend as ByteArray, divisor as ByteArray) as ByteArray {
        var rest = dividend.slice(null, null);
        var quotientLength = dividend.size()-divisor.size()+1;
        for (var i=0; i<quotientLength; i++) {
            if (rest[0]!=0) {
                var factor = div(rest[0], divisor[0]);
                var subtr = polyMul(divisor, [factor]b);
                while (subtr.size()<rest.size()) {subtr.add(0);}
                for (var j=0; j<rest.size(); j++) {
                    rest[j] ^= subtr[j];
                }
            }
            rest = rest.slice(1, null);
        }
        return rest;
    }
}