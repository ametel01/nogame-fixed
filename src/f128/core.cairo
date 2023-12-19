use nogame_fixed::f128::types::{Fixed, FixedTrait, ONE_u128};
use nogame_fixed::f128::lut;

fn abs(a: Fixed) -> Fixed {
    return FixedTrait::new(a.mag, false);
}

fn add(a: Fixed, b: Fixed) -> Fixed {
    if a.sign == b.sign {
        return FixedTrait::new(a.mag + b.mag, a.sign);
    }

    if a.mag == b.mag {
        return FixedTrait::ZERO();
    }

    if (a.mag > b.mag) {
        return FixedTrait::new(a.mag - b.mag, a.sign);
    } else {
        return FixedTrait::new(b.mag - a.mag, b.sign);
    }
}

fn div(a: Fixed, b: Fixed) -> Fixed {
    let (a_high, a_low) = core::integer::u128_wide_mul(a.mag, ONE_u128);
    let a_u256 = u256 { low: a_low, high: a_high };
    let b_u256 = u256 { low: b.mag, high: 0 };
    let res_u256 = a_u256 / b_u256;

    assert(res_u256.high == 0, 'result overflow');

    // Re-apply sign
    return FixedTrait::new(res_u256.low, a.sign ^ b.sign);
}

fn exp(a: Fixed) -> Fixed {
    return exp2(FixedTrait::new(26613026195688644984, false) * a);
}

// Calculates the binary exponent of x: 2^x
fn exp2(a: Fixed) -> Fixed {
    if (a.mag == 0) {
        return FixedTrait::ONE();
    }

    let (int_part, frac_part) = _split_unsigned(a);
    let int_res = FixedTrait::new_unscaled(lut::exp2(int_part), false);
    let mut res_u = int_res;

    if frac_part != 0 {
        let frac_fixed = FixedTrait::new(frac_part, false);
        let r8 = FixedTrait::new(41691949755436, false) * frac_fixed;
        let r7 = (r8 + FixedTrait::new(231817862090993, false)) * frac_fixed;
        let r6 = (r7 + FixedTrait::new(2911875592466782, false)) * frac_fixed;
        let r5 = (r6 + FixedTrait::new(24539637786416367, false)) * frac_fixed;
        let r4 = (r5 + FixedTrait::new(177449490038807528, false)) * frac_fixed;
        let r3 = (r4 + FixedTrait::new(1023863119786103800, false)) * frac_fixed;
        let r2 = (r3 + FixedTrait::new(4431397849999009866, false)) * frac_fixed;
        let r1 = (r2 + FixedTrait::new(12786308590235521577, false)) * frac_fixed;
        res_u = res_u * (r1 + FixedTrait::ONE());
    }

    if (a.sign == true) {
        return FixedTrait::ONE() / res_u;
    } else {
        return res_u;
    }
}

fn mul(a: Fixed, b: Fixed) -> Fixed {
    let (high, low) = core::integer::u128_wide_mul(a.mag, b.mag);
    let res_u256 = u256 { low: low, high: high };
    let ONE_u256 = u256 { low: ONE_u128, high: 0 };
    let (scaled_u256, _) = core::integer::u256_safe_div_rem(res_u256, core::integer::u256_as_non_zero(ONE_u256));

    assert(scaled_u256.high == 0, 'result overflow');

    // Re-apply sign
    return FixedTrait::new(scaled_u256.low, a.sign ^ b.sign);
}

fn sub(a: Fixed, b: Fixed) -> Fixed {
    return add(a, -b);
}

fn neg(a: Fixed) -> Fixed {
    if a.mag == 0 {
        return a;
    } else if !a.sign {
        return FixedTrait::new(a.mag, !a.sign);
    } else {
        return FixedTrait::new(a.mag, false);
    }
}

fn ln(a: Fixed) -> Fixed {
    return FixedTrait::new(12786308645202655660, false) * log2(a); // ln(2) = 0.693...
}

// Calculates the binary logarithm of x: log2(x)
// self must be greather than zero
fn log2(a: Fixed) -> Fixed {
    assert(a.sign == false, 'must be positive');

    if (a.mag == ONE_u128) {
        return FixedTrait::ZERO();
    } else if (a.mag < ONE_u128) {
        // Compute true inverse binary log if 0 < x < 1
        let div = FixedTrait::ONE() / a;
        return -log2(div);
    }

    let (msb, div) = lut::msb(a.mag / ONE_u128);
    let norm = a / FixedTrait::new_unscaled(div, false);

    let r8 = FixedTrait::new(167660832607149504, true) * norm;
    let r7 = (r8 + FixedTrait::new(2284550827067371376, false)) * norm;
    let r6 = (r7 + FixedTrait::new(13804762162529339368, true)) * norm;
    let r5 = (r6 + FixedTrait::new(48676798788932142400, false)) * norm;
    let r4 = (r5 + FixedTrait::new(110928274989790216568, true)) * norm;
    let r3 = (r4 + FixedTrait::new(171296190111888966192, false)) * norm;
    let r2 = (r3 + FixedTrait::new(184599081115266689944, true)) * norm;
    let r1 = (r2 + FixedTrait::new(150429590981271126408, false)) * norm;
    return r1 + FixedTrait::new(63187350828072553424, true) + FixedTrait::new_unscaled(msb, false);
}

fn sqrt(a: Fixed) -> Fixed {
    assert(a.sign == false, 'must be positive');
    let root = core::integer::u128_sqrt(a.mag);
    let scale_root = core::integer::u128_sqrt(ONE_u128);
    let res_u128 = core::integer::upcast(root) * ONE_u128 / core::integer::upcast(scale_root);
    return FixedTrait::new(res_u128, false);
}

fn _split_unsigned(a: Fixed) -> (u128, u128) {
    return core::integer::u128_safe_divmod(a.mag, core::integer::u128_as_non_zero(ONE_u128));
}