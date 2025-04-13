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

fn msb(whole: u128) -> (u128, u128) {
    if whole < 256 {
        if whole < 2 {
            return (0, 1);
        }
        if whole < 4 {
            return (1, 2);
        }
        if whole < 8 {
            return (2, 4);
        }
        if whole < 16 {
            return (3, 8);
        }
        if whole < 32 {
            return (4, 16);
        }
        if whole < 64 {
            return (5, 32);
        }
        if whole < 128 {
            return (6, 64);
        }
        if whole < 256 {
            return (7, 128);
        }
    } else if whole < 65536 {
        if whole < 512 {
            return (8, 256);
        }
        if whole < 1024 {
            return (9, 512);
        }
        if whole < 2048 {
            return (10, 1024);
        }
        if whole < 4096 {
            return (11, 2048);
        }
        if whole < 8192 {
            return (12, 4096);
        }
        if whole < 16384 {
            return (13, 8192);
        }
        if whole < 32768 {
            return (14, 16384);
        }
        if whole < 65536 {
            return (15, 32768);
        }
    } else if whole < 16777216 {
        if whole < 131072 {
            return (16, 65536);
        }
        if whole < 262144 {
            return (17, 131072);
        }
        if whole < 524288 {
            return (18, 262144);
        }
        if whole < 1048576 {
            return (19, 524288);
        }
        if whole < 2097152 {
            return (20, 1048576);
        }
        if whole < 4194304 {
            return (21, 2097152);
        }
        if whole < 8388608 {
            return (22, 4194304);
        }
        if whole < 16777216 {
            return (23, 8388608);
        }
    } else if whole < 4294967296 {
        if whole < 33554432 {
            return (24, 16777216);
        }
        if whole < 67108864 {
            return (25, 33554432);
        }
        if whole < 134217728 {
            return (26, 67108864);
        }
        if whole < 268435456 {
            return (27, 134217728);
        }
        if whole < 536870912 {
            return (28, 268435456);
        }
        if whole < 1073741824 {
            return (29, 536870912);
        }
        if whole < 2147483648 {
            return (30, 1073741824);
        }
        if whole < 4294967296 {
            return (31, 2147483648);
        }
    } else if whole < 1099511627776 {
        if whole < 8589934592 {
            return (32, 4294967296);
        }
        if whole < 17179869184 {
            return (33, 8589934592);
        }
        if whole < 34359738368 {
            return (34, 17179869184);
        }
        if whole < 68719476736 {
            return (35, 34359738368);
        }
        if whole < 137438953472 {
            return (36, 68719476736);
        }
        if whole < 274877906944 {
            return (37, 137438953472);
        }
        if whole < 549755813888 {
            return (38, 274877906944);
        }
        if whole < 1099511627776 {
            return (39, 549755813888);
        }
    } else if whole < 281474976710656 {
        if whole < 2199023255552 {
            return (40, 1099511627776);
        }
        if whole < 4398046511104 {
            return (41, 2199023255552);
        }
        if whole < 8796093022208 {
            return (42, 4398046511104);
        }
        if whole < 17592186044416 {
            return (43, 8796093022208);
        }
        if whole < 35184372088832 {
            return (44, 17592186044416);
        }
        if whole < 70368744177664 {
            return (45, 35184372088832);
        }
        if whole < 140737488355328 {
            return (46, 70368744177664);
        }
        if whole < 281474976710656 {
            return (47, 140737488355328);
        }
    } else if whole < 72057594037927936 {
        if whole < 562949953421312 {
            return (48, 281474976710656);
        }
        if whole < 1125899906842624 {
            return (49, 562949953421312);
        }
        if whole < 2251799813685248 {
            return (50, 1125899906842624);
        }
        if whole < 4503599627370496 {
            return (51, 2251799813685248);
        }
        if whole < 9007199254740992 {
            return (52, 4503599627370496);
        }
        if whole < 18014398509481984 {
            return (53, 9007199254740992);
        }
        if whole < 36028797018963968 {
            return (54, 18014398509481984);
        }
        if whole < 72057594037927936 {
            return (55, 36028797018963968);
        }
    } else {
        if whole < 144115188075855872 {
            return (56, 72057594037927936);
        }
        if whole < 288230376151711744 {
            return (57, 144115188075855872);
        }
        if whole < 576460752303423488 {
            return (58, 288230376151711744);
        }
        if whole < 1152921504606846976 {
            return (59, 576460752303423488);
        }
        if whole < 2305843009213693952 {
            return (60, 1152921504606846976);
        }
        if whole < 4611686018427387904 {
            return (61, 2305843009213693952);
        }
        if whole < 9223372036854775808 {
            return (62, 4611686018427387904);
        }
        if whole < 18446744073709551616 {
            return (63, 9223372036854775808);
        }
    }

    return (64, 18446744073709551616);
}

#[cfg(test)]
mod tests {
    use super::{exp2, msb};
    
    #[test]
    fn test_exp2_lookup() {
        // Test some specific values from the lookup table
        assert(exp2(0) == 1, 'exp2(0) should be 1');
        assert(exp2(1) == 2, 'exp2(1) should be 2');
        assert(exp2(2) == 4, 'exp2(2) should be 4');
        assert(exp2(3) == 8, 'exp2(3) should be 8');
        assert(exp2(4) == 16, 'exp2(4) should be 16');
        assert(exp2(10) == 1024, 'exp2(10) should be 1024');
        assert(exp2(16) == 65536, 'exp2(16) should be 65536');
        assert(exp2(32) == 4294967296, 'exp2(32) should be 4294967296');
        assert(exp2(63) == 9223372036854775808, 'exp2(63) wrong');
        assert(exp2(64) == 18446744073709551616, 'exp2(64) wrong');
        
        // Test values that exceed the table (should return the largest value)
        assert(exp2(65) == 18446744073709551616, 'exp2(65) should default to max');
        assert(exp2(100) == 18446744073709551616, 'exp2(100) should default to max');
    }
    
    #[test]
    fn test_msb_function() {
        // Test powers of 2
        let (msb_val, div_val) = msb(1);
        assert(msb_val == 0, 'msb(1) should be 0');
        assert(div_val == 1, 'div(1) should be 1');
        
        let (msb_val, div_val) = msb(2);
        assert(msb_val == 1, 'msb(2) should be 1');
        assert(div_val == 2, 'div(2) should be 2');
        
        let (msb_val, div_val) = msb(4);
        assert(msb_val == 2, 'msb(4) should be 2');
        assert(div_val == 4, 'div(4) should be 4');
        
        let (msb_val, div_val) = msb(8);
        assert(msb_val == 3, 'msb(8) should be 3');
        assert(div_val == 8, 'div(8) should be 8');
        
        let (msb_val, div_val) = msb(16);
        assert(msb_val == 4, 'msb(16) should be 4');
        assert(div_val == 16, 'div(16) should be 16');
        
        // Test non-powers of 2
        let (msb_val, div_val) = msb(3);
        assert(msb_val == 1, 'msb(3) should be 1');
        assert(div_val == 2, 'div(3) should be 2');
        
        let (msb_val, div_val) = msb(5);
        assert(msb_val == 2, 'msb(5) should be 2');
        assert(div_val == 4, 'div(5) should be 4');
        
        let (msb_val, div_val) = msb(7);
        assert(msb_val == 2, 'msb(7) should be 2');
        assert(div_val == 4, 'div(7) should be 4');
        
        let (msb_val, div_val) = msb(9);
        assert(msb_val == 3, 'msb(9) should be 3');
        assert(div_val == 8, 'div(9) should be 8');
        
        let (msb_val, div_val) = msb(10);
        assert(msb_val == 3, 'msb(10) should be 3');
        assert(div_val == 8, 'div(10) should be 8');
        
        // Test larger numbers
        let (msb_val, div_val) = msb(1000);
        assert(msb_val == 9, 'msb(1000) should be 9');
        assert(div_val == 512, 'div(1000) should be 512');
        
        let (msb_val, div_val) = msb(1048576); // 2^20
        assert(msb_val == 20, 'msb(2^20) should be 20');
        assert(div_val == 1048576, 'div(2^20) should be 2^20');
        
        let (msb_val, div_val) = msb(1048577); // 2^20 + 1
        assert(msb_val == 20, 'msb(2^20+1) should be 20');
        assert(div_val == 1048576, 'div(2^20+1) should be 2^20');
    }
}