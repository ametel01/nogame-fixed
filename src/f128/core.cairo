use nogame_fixed::f128::types::{Fixed, FixedTrait, ONE_u128};
use nogame_fixed::f128::lut;
use core::num::traits::{WideMul, Sqrt};

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
    let res = WideMul::wide_mul(a.mag, ONE_u128);
    let res_u256 = u256 { low: res.low, high: res.high };
    let b_u256 = u256 { low: b.mag, high: 0 };
    let res_u256 = res_u256 / b_u256;

    assert(res_u256.high == 0, 'result overflow');

    // Re-apply sign
    return FixedTrait::new(res_u256.low, a.sign ^ b.sign);
}

fn pow(a: Fixed, b: Fixed) -> Fixed {
    let (_, rem_u128) = _split_unsigned(b);

    // use the more performant integer pow when y is an int
    if (rem_u128 == 0) {
        return pow_int(a, b.mag / ONE_u128, b.sign);
    }

    // x^y = exp(y*ln(x)) for x > 0 will error for x < 0
    return exp(b * ln(a));
}

fn pow_int(a: Fixed, b: u128, sign: bool) -> Fixed {
    let mut x = a;
    let mut n = b;

    if sign {
        x = FixedTrait::ONE() / x;
    }

    if n == 0 {
        return FixedTrait::ONE();
    }

    let mut y = FixedTrait::ONE();
    let two = core::integer::u128_as_non_zero(2);

    while n != 1 {
        let (div, rem) = core::integer::u128_safe_divmod(n, two);

        if rem == 1 {
            y = x * y;
        }

        x = x * x;
        n = div;
    };

    return x * y;
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

    if a.sign {
        return FixedTrait::ONE() / res_u;
    } else {
        return res_u;
    }
}

fn mul(a: Fixed, b: Fixed) -> Fixed {
    let res = WideMul::wide_mul(a.mag, b.mag);
    let res_u256 = u256 { low: res.low, high: res.high };
    let ONE_u256 = u256 { low: ONE_u128, high: 0 };
    let (scaled_u256, _) = core::integer::u256_safe_div_rem(
        res_u256, core::integer::u256_as_non_zero(ONE_u256),
    );

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
    assert(!a.sign, 'must be positive');

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
    assert(!a.sign, 'must be positive');
    let root = Sqrt::sqrt(a.mag);
    let scale_root = Sqrt::sqrt(ONE_u128);
    let res_u128 = core::integer::upcast(root) * ONE_u128 / core::integer::upcast(scale_root);
    return FixedTrait::new(res_u128, false);
}

fn _split_unsigned(a: Fixed) -> (u128, u128) {
    return core::integer::u128_safe_divmod(a.mag, core::integer::u128_as_non_zero(ONE_u128));
}

#[cfg(test)]
mod tests {
    use nogame_fixed::f128::types::{Fixed, FixedTrait, ONE_u128};
    use super::{
        abs, add, div, exp, exp2, ln, log2, mul, neg, pow, pow_int, sqrt, sub, _split_unsigned,
    };

    #[test]
    fn test_abs_function() {
        let negative = FixedTrait::new(123456789, true);
        let result = abs(negative);
        assert(result.mag == 123456789, 'abs mag should be preserved');
        assert(result.sign == false, 'abs sign should be false');
    }

    #[test]
    fn test_add_function() {
        // Test same sign
        let a = FixedTrait::new(100, false);
        let b = FixedTrait::new(50, false);
        let sum = add(a, b);
        assert(sum.mag == 150, 'add should sum mags');
        assert(sum.sign == false, 'sign should be preserved');

        // Test diff signs (a > b)
        let a = FixedTrait::new(100, false);
        let b = FixedTrait::new(50, true);
        let sum = add(a, b);
        assert(sum.mag == 50, 'add should subtract mags');
        assert(sum.sign == false, 'sign should follow larger');

        // Test diff signs (a < b)
        let a = FixedTrait::new(50, false);
        let b = FixedTrait::new(100, true);
        let sum = add(a, b);
        assert(sum.mag == 50, 'add should subtract mags');
        assert(sum.sign == true, 'sign should follow larger');

        // Test equal magnitude opposite signs
        let a = FixedTrait::new(100, false);
        let b = FixedTrait::new(100, true);
        let sum = add(a, b);
        assert(sum.mag == 0, 'should be zero');
        assert(sum.sign == false, 'zero should be positive');
    }

    #[test]
    fn test_div_function() {
        // Test basic division
        let a = FixedTrait::new(6 * ONE_u128, false);
        let b = FixedTrait::new(3 * ONE_u128, false);
        let result = div(a, b);
        assert(result.mag == 2 * ONE_u128, 'div should be 2');
        assert(result.sign == false, 'div sign should be false');

        // Test division with different signs
        let a = FixedTrait::new(6 * ONE_u128, false);
        let b = FixedTrait::new(3 * ONE_u128, true);
        let result = div(a, b);
        assert(result.mag == 2 * ONE_u128, 'div should be 2');
        assert(result.sign == true, 'div sign should be true');
    }

    #[test]
    fn test_pow_function() {
        // Test x^1 = x
        let x = FixedTrait::new(3 * ONE_u128, false);
        let exp = FixedTrait::ONE();
        let result = pow(x, exp);

        let diff = if result.mag > x.mag {
            result.mag - x.mag
        } else {
            x.mag - result.mag
        };
        assert(diff < ONE_u128 / 1000000, 'x^1 should be x');

        // Test x^0 = 1
        let result = pow(x, FixedTrait::ZERO());
        let diff = if result.mag > ONE_u128 {
            result.mag - ONE_u128
        } else {
            ONE_u128 - result.mag
        };
        assert(diff < ONE_u128 / 1000000, 'x^0 should be 1');

        // Test integer power (x^2 = x*x)
        let exp = FixedTrait::new(2 * ONE_u128, false);
        let result = pow(x, exp);
        let expected = mul(x, x);

        let diff = if result.mag > expected.mag {
            result.mag - expected.mag
        } else {
            expected.mag - result.mag
        };
        assert(diff < ONE_u128 / 1000000, 'x^2 should be x*x');
    }

    #[test]
    fn test_pow_int_function() {
        // Test x^2 = x*x
        let x = FixedTrait::new(3 * ONE_u128, false);
        let result = pow_int(x, 2, false);
        let expected = mul(x, x);

        let diff = if result.mag > expected.mag {
            result.mag - expected.mag
        } else {
            expected.mag - result.mag
        };
        assert(diff < ONE_u128 / 1000000, 'x^2 should be x*x');

        // Test x^0 = 1
        let result = pow_int(x, 0, false);
        assert(result.mag == ONE_u128, 'x^0 should be 1');
        assert(result.sign == false, 'x^0 sign should be false');

        // Test negative exponent: x^-n = 1/x^n
        let result = pow_int(x, 2, true);
        let expected = div(FixedTrait::ONE(), mul(x, x));

        let diff = if result.mag > expected.mag {
            result.mag - expected.mag
        } else {
            expected.mag - result.mag
        };
        assert(diff < ONE_u128 / 1000000, 'x^-2 should be 1/x^2');
    }

    #[test]
    fn test_exp_function() {
        // Test e^0 = 1
        let zero = FixedTrait::ZERO();
        let result = exp(zero);
        assert(result.mag == ONE_u128, 'e^0 should be 1');
        assert(result.sign == false, 'e^0 sign should be false');

        // Test e^1 ≈ 2.718
        let one = FixedTrait::ONE();
        let result = exp(one);
        // The exact value should be close to 2.718 * ONE_u128
        assert(result.mag > 2 * ONE_u128, 'e^1 should be > 2');
        assert(result.mag < 3 * ONE_u128, 'e^1 should be < 3');
        assert(result.sign == false, 'e^1 sign should be false');

        // Test e^-x = 1/e^x
        let neg_one = FixedTrait::new(ONE_u128, true);
        let result_neg = exp(neg_one);
        let expected = div(FixedTrait::ONE(), exp(one));

        // Allow small precision error
        let diff = if result_neg.mag > expected.mag {
            result_neg.mag - expected.mag
        } else {
            expected.mag - result_neg.mag
        };
        assert(diff < ONE_u128 / 1000000, 'e^-1 should be 1/e^1');
    }

    #[test]
    fn test_exp2_function() {
        // Test 2^0 = 1
        let zero = FixedTrait::ZERO();
        let result = exp2(zero);
        assert(result.mag == ONE_u128, '2^0 should be 1');
        assert(result.sign == false, '2^0 sign should be false');

        // Test 2^1 = 2
        let one = FixedTrait::ONE();
        let result = exp2(one);
        let expected = FixedTrait::new(2 * ONE_u128, false);

        // Allow small precision error
        let diff = if result.mag > expected.mag {
            result.mag - expected.mag
        } else {
            expected.mag - result.mag
        };
        assert(diff < ONE_u128 / 1000000, '2^1 should be 2');

        // Test 2^-1 = 0.5
        let neg_one = FixedTrait::new(ONE_u128, true);
        let result = exp2(neg_one);
        let expected = FixedTrait::new(ONE_u128 / 2, false);

        // Allow small precision error
        let diff = if result.mag > expected.mag {
            result.mag - expected.mag
        } else {
            expected.mag - result.mag
        };
        assert(diff < ONE_u128 / 1000000, '2^-1 should be 0.5');
    }

    #[test]
    fn test_ln_function() {
        // Test ln(1) = 0
        let one = FixedTrait::ONE();
        let result = ln(one);
        assert(result.mag < ONE_u128 / 1000000, 'ln(1) should be close to 0');

        // Test ln(e) = 1
        let e = exp(FixedTrait::ONE());
        let result = ln(e);

        // Allow small precision error
        let diff = if result.mag > ONE_u128 {
            result.mag - ONE_u128
        } else {
            ONE_u128 - result.mag
        };
        assert(diff < ONE_u128 / 1000000, 'ln(e) should be close to 1');
    }

    #[test]
    fn test_log2_function() {
        // Test log2(1) = 0
        let one = FixedTrait::ONE();
        let result = log2(one);
        assert(result.mag < ONE_u128 / 1000000, 'log2(1) should be close to 0');

        // Test log2(2) = 1
        let two = FixedTrait::new(2 * ONE_u128, false);
        let result = log2(two);

        // Allow small precision error
        let diff = if result.mag > ONE_u128 {
            result.mag - ONE_u128
        } else {
            ONE_u128 - result.mag
        };
        assert(diff < ONE_u128 / 1000000, 'log2(2) should be close to 1');

        // Test log2(4) = 2
        let four = FixedTrait::new(4 * ONE_u128, false);
        let result = log2(four);
        let expected = FixedTrait::new(2 * ONE_u128, false);

        // Allow small precision error
        let diff = if result.mag > expected.mag {
            result.mag - expected.mag
        } else {
            expected.mag - result.mag
        };
        assert(diff < ONE_u128 / 1000000, 'log2(4) should be close to 2');
    }

    #[test]
    fn test_mul_function() {
        // Test multiplication of positive numbers
        let a = FixedTrait::new(2 * ONE_u128, false);
        let b = FixedTrait::new(3 * ONE_u128, false);
        let result = mul(a, b);
        assert(result.mag == 6 * ONE_u128, 'mul should be 6');
        assert(result.sign == false, 'mul sign should be false');

        // Test multiplication with negative sign
        let a = FixedTrait::new(2 * ONE_u128, false);
        let b = FixedTrait::new(3 * ONE_u128, true);
        let result = mul(a, b);
        assert(result.mag == 6 * ONE_u128, 'mul should be 6');
        assert(result.sign == true, 'mul sign should be true');

        // Test multiplication with both negative signs
        let a = FixedTrait::new(2 * ONE_u128, true);
        let b = FixedTrait::new(3 * ONE_u128, true);
        let result = mul(a, b);
        assert(result.mag == 6 * ONE_u128, 'mul should be 6');
        assert(result.sign == false, 'mul sign should be false');
    }

    #[test]
    fn test_sub_function() {
        // Test a - b (a > b)
        let a = FixedTrait::new(100, false);
        let b = FixedTrait::new(50, false);
        let result = sub(a, b);
        assert(result.mag == 50, 'sub should be 50');
        assert(result.sign == false, 'sub sign should be false');

        // Test a - b (a < b)
        let a = FixedTrait::new(50, false);
        let b = FixedTrait::new(100, false);
        let result = sub(a, b);
        assert(result.mag == 50, 'sub should be 50');
        assert(result.sign == true, 'sub sign should be true');

        // Test a - (-b)
        let a = FixedTrait::new(50, false);
        let b = FixedTrait::new(100, true);
        let result = sub(a, b);
        assert(result.mag == 150, 'sub should be 150');
        assert(result.sign == false, 'sub sign should be false');
    }

    #[test]
    fn test_neg_function() {
        // Test negation of positive number
        let a = FixedTrait::new(100, false);
        let result = neg(a);
        assert(result.mag == 100, 'neg mag should be preserved');
        assert(result.sign == true, 'neg sign should be negated');

        // Test negation of negative number
        let a = FixedTrait::new(100, true);
        let result = neg(a);
        assert(result.mag == 100, 'neg mag should be preserved');
        assert(result.sign == false, 'neg sign should be negated');

        // Test negation of zero
        let zero = FixedTrait::ZERO();
        let result = neg(zero);
        assert(result.mag == 0, 'neg zero mag should be 0');
        assert(result.sign == false, 'neg zero sign should be false');
    }

    #[test]
    fn test_sqrt_function() {
        // Test sqrt(4) = 2
        let four = FixedTrait::new(4 * ONE_u128, false);
        let result = sqrt(four);
        let expected = FixedTrait::new(2 * ONE_u128, false);

        // Allow small precision error
        let diff = if result.mag > expected.mag {
            result.mag - expected.mag
        } else {
            expected.mag - result.mag
        };
        assert(diff < ONE_u128 / 1000000, 'sqrt(4) should be 2');

        // Test sqrt(9) = 3
        let nine = FixedTrait::new(9 * ONE_u128, false);
        let result = sqrt(nine);
        let expected = FixedTrait::new(3 * ONE_u128, false);

        // Allow small precision error
        let diff = if result.mag > expected.mag {
            result.mag - expected.mag
        } else {
            expected.mag - result.mag
        };
        assert(diff < ONE_u128 / 1000000, 'sqrt(9) should be 3');
    }

    #[test]
    fn test_split_unsigned() {
        // Test integer part = 5, fractional part = 0
        let a = FixedTrait::new_unscaled(5, false);
        let (int_part, frac_part) = _split_unsigned(a);
        assert(int_part == 5, 'int part should be 5');
        assert(frac_part == 0, 'frac part should be 0');

        // Test with fractional part
        let a = FixedTrait::new(ONE_u128 + ONE_u128 / 4, false); // 1.25
        let (int_part, frac_part) = _split_unsigned(a);
        assert(int_part == 1, 'int part should be 1');
        assert(frac_part == ONE_u128 / 4, 'frac part should be 0.25');
    }
}
