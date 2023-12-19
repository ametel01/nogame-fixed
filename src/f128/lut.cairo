fn exp2(exp: u128) -> u128 {
    if exp <= 16 {
        if exp == 0 {
            return 1;
        }
        if exp == 1 {
            return 2;
        }
        if exp == 2 {
            return 4;
        }
        if exp == 3 {
            return 8;
        }
        if exp == 4 {
            return 16;
        }
        if exp == 5 {
            return 32;
        }
        if exp == 6 {
            return 64;
        }
        if exp == 7 {
            return 128;
        }
        if exp == 8 {
            return 256;
        }
        if exp == 9 {
            return 512;
        }
        if exp == 10 {
            return 1024;
        }
        if exp == 11 {
            return 2048;
        }
        if exp == 12 {
            return 4096;
        }
        if exp == 13 {
            return 8192;
        }
        if exp == 14 {
            return 16384;
        }
        if exp == 15 {
            return 32768;
        }
        if exp == 16 {
            return 65536;
        }
    } else if exp <= 32 {
        if exp == 17 {
            return 131072;
        }
        if exp == 18 {
            return 262144;
        }
        if exp == 19 {
            return 524288;
        }
        if exp == 20 {
            return 1048576;
        }
        if exp == 21 {
            return 2097152;
        }
        if exp == 22 {
            return 4194304;
        }
        if exp == 23 {
            return 8388608;
        }
        if exp == 24 {
            return 16777216;
        }
        if exp == 25 {
            return 33554432;
        }
        if exp == 26 {
            return 67108864;
        }
        if exp == 27 {
            return 134217728;
        }
        if exp == 28 {
            return 268435456;
        }
        if exp == 29 {
            return 536870912;
        }
        if exp == 30 {
            return 1073741824;
        }
        if exp == 31 {
            return 2147483648;
        }
        if exp == 32 {
            return 4294967296;
        }
    } else if exp <= 48 {
        if exp == 33 {
            return 8589934592;
        }
        if exp == 34 {
            return 17179869184;
        }
        if exp == 35 {
            return 34359738368;
        }
        if exp == 36 {
            return 68719476736;
        }
        if exp == 37 {
            return 137438953472;
        }
        if exp == 38 {
            return 274877906944;
        }
        if exp == 39 {
            return 549755813888;
        }
        if exp == 40 {
            return 1099511627776;
        }
        if exp == 41 {
            return 2199023255552;
        }
        if exp == 42 {
            return 4398046511104;
        }
        if exp == 43 {
            return 8796093022208;
        }
        if exp == 44 {
            return 17592186044416;
        }
        if exp == 45 {
            return 35184372088832;
        }
        if exp == 46 {
            return 70368744177664;
        }
        if exp == 47 {
            return 140737488355328;
        }
        if exp == 48 {
            return 281474976710656;
        }
    } else {
        if exp == 49 {
            return 562949953421312;
        }
        if exp == 50 {
            return 1125899906842624;
        }
        if exp == 51 {
            return 2251799813685248;
        }
        if exp == 52 {
            return 4503599627370496;
        }
        if exp == 53 {
            return 9007199254740992;
        }
        if exp == 54 {
            return 18014398509481984;
        }
        if exp == 55 {
            return 36028797018963968;
        }
        if exp == 56 {
            return 72057594037927936;
        }
        if exp == 57 {
            return 144115188075855872;
        }
        if exp == 58 {
            return 288230376151711744;
        }
        if exp == 59 {
            return 576460752303423488;
        }
        if exp == 60 {
            return 1152921504606846976;
        }
        if exp == 61 {
            return 2305843009213693952;
        }
        if exp == 62 {
            return 4611686018427387904;
        }
        if exp == 63 {
            return 9223372036854775808;
        }
    }

    return 18446744073709551616;
}
