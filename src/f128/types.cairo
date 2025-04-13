use nogame_fixed::f128::core::{abs, add, div, exp, ln, mul, neg, sub};

const ONE_u128: u128 = 18446744073709551616_u128;
const ONE: felt252 = 18446744073709551616;

#[derive(Copy, Drop, Serde)]
struct Fixed {
    mag: u128,
    sign: bool,
}

// TRAITS

trait FixedTrait {
    fn ZERO() -> Fixed;
    fn ONE() -> Fixed;
    fn abs(self: Fixed) -> Fixed;

    // Constructors
    fn new(mag: u128, sign: bool) -> Fixed;
    fn new_unscaled(mag: u128, sign: bool) -> Fixed;

    // Math
    fn exp(self: Fixed) -> Fixed;
    fn ln(self: Fixed) -> Fixed;
}

impl FixedImpl of FixedTrait {
    fn ZERO() -> Fixed {
        return Fixed { mag: 0, sign: false };
    }

    fn ONE() -> Fixed {
        return Fixed { mag: ONE_u128, sign: false };
    }

    fn new(mag: u128, sign: bool) -> Fixed {
        return Fixed { mag: mag, sign: sign };
    }

    fn new_unscaled(mag: u128, sign: bool) -> Fixed {
        return Self::new(mag * ONE_u128, sign);
    }

    fn abs(self: Fixed) -> Fixed {
        return abs(self);
    }

    fn exp(self: Fixed) -> Fixed {
        return exp(self);
    }

    fn ln(self: Fixed) -> Fixed {
        return ln(self);
    }
}

impl FixedAdd of Add<Fixed> {
    fn add(lhs: Fixed, rhs: Fixed) -> Fixed {
        return add(lhs, rhs);
    }
}

impl FixedDiv of Div<Fixed> {
    fn div(lhs: Fixed, rhs: Fixed) -> Fixed {
        return div(lhs, rhs);
    }
}

impl FixedMul of Mul<Fixed> {
    fn mul(lhs: Fixed, rhs: Fixed) -> Fixed {
        return mul(lhs, rhs);
    }
}

impl FixedSub of Sub<Fixed> {
    fn sub(lhs: Fixed, rhs: Fixed) -> Fixed {
        return sub(lhs, rhs);
    }
}

impl FixedNeg of Neg<Fixed> {
    #[inline(always)]
    fn neg(a: Fixed) -> Fixed {
        return neg(a);
    }
}

#[cfg(test)]
mod tests {
    use super::{Fixed, FixedTrait, ONE_u128};
    use nogame_fixed::f128::core::{abs, add, div, exp, ln, mul, neg, pow, sqrt, sub};

    #[test]
    fn test_zero() {
        let zero = FixedTrait::ZERO();
        assert(zero.mag == 0, 'ZERO mag should be 0');
        assert(zero.sign == false, 'ZERO sign should be false');
    }

    #[test]
    fn test_one() {
        let one = FixedTrait::ONE();
        assert(one.mag == ONE_u128, 'ONE mag should be ONE_u128');
        assert(one.sign == false, 'ONE sign should be false');
    }

    #[test]
    fn test_new() {
        let value = FixedTrait::new(123456789, true);
        assert(value.mag == 123456789, 'mag should be 123456789');
        assert(value.sign == true, 'sign should be true');
    }

    #[test]
    fn test_new_unscaled() {
        let value = FixedTrait::new_unscaled(5, false);
        assert(value.mag == 5 * ONE_u128, 'mag should be scaled');
        assert(value.sign == false, 'sign should be false');
    }

    #[test]
    fn test_abs() {
        let negative = FixedTrait::new(123456789, true);
        let positive = FixedTrait::new(123456789, false);

        let abs_negative = negative.abs();
        let abs_positive = positive.abs();

        assert(abs_negative.mag == 123456789, 'abs mag should be preserved');
        assert(abs_negative.sign == false, 'abs sign should be false');
        assert(abs_positive.mag == 123456789, 'abs mag should be preserved');
        assert(abs_positive.sign == false, 'abs sign should be false');
    }

    #[test]
    fn test_add() {
        // Test same sign addition
        let a = FixedTrait::new(100, false);
        let b = FixedTrait::new(50, false);
        let sum = a + b;
        assert(sum.mag == 150, 'sum mag should be 150');
        assert(sum.sign == false, 'sum sign should be false');

        // Test opposite sign addition (a > b)
        let a = FixedTrait::new(100, false);
        let b = FixedTrait::new(50, true);
        let sum = a + b;
        assert(sum.mag == 50, 'sum mag should be 50');
        assert(sum.sign == false, 'sum sign should be false');

        // Test opposite sign addition (a < b)
        let a = FixedTrait::new(50, false);
        let b = FixedTrait::new(100, true);
        let sum = a + b;
        assert(sum.mag == 50, 'sum mag should be 50');
        assert(sum.sign == true, 'sum sign should be true');

        // Test opposite sign addition (a = b)
        let a = FixedTrait::new(100, false);
        let b = FixedTrait::new(100, true);
        let sum = a + b;
        assert(sum.mag == 0, 'sum mag should be 0');
        assert(sum.sign == false, 'sum sign should be false');
    }

    #[test]
    fn test_sub() {
        // Test subtraction (a > b)
        let a = FixedTrait::new(100, false);
        let b = FixedTrait::new(50, false);
        let diff = a - b;
        assert(diff.mag == 50, 'diff mag should be 50');
        assert(diff.sign == false, 'diff sign should be false');

        // Test subtraction (a < b)
        let a = FixedTrait::new(50, false);
        let b = FixedTrait::new(100, false);
        let diff = a - b;
        assert(diff.mag == 50, 'diff mag should be 50');
        assert(diff.sign == true, 'diff sign should be true');
    }

    #[test]
    fn test_mul() {
        // Test multiplication of positive numbers
        let a = FixedTrait::new(2 * ONE_u128, false);
        let b = FixedTrait::new(3 * ONE_u128, false);
        let product = a * b;
        assert(product.mag == 6 * ONE_u128, 'product mag should be 6*ONE');
        assert(product.sign == false, 'product sign should be false');

        // Test multiplication with different signs
        let a = FixedTrait::new(2 * ONE_u128, false);
        let b = FixedTrait::new(3 * ONE_u128, true);
        let product = a * b;
        assert(product.mag == 6 * ONE_u128, 'product mag should be 6*ONE');
        assert(product.sign == true, 'product sign should be true');
    }

    #[test]
    fn test_div() {
        // Test division of positive numbers
        let a = FixedTrait::new(6 * ONE_u128, false);
        let b = FixedTrait::new(2 * ONE_u128, false);
        let quotient = a / b;
        assert(quotient.mag == 3 * ONE_u128, 'quotient mag should be 3*ONE');
        assert(quotient.sign == false, 'quotient sign should be false');

        // Test division with different signs
        let a = FixedTrait::new(6 * ONE_u128, false);
        let b = FixedTrait::new(2 * ONE_u128, true);
        let quotient = a / b;
        assert(quotient.mag == 3 * ONE_u128, 'quotient mag should be 3*ONE');
        assert(quotient.sign == true, 'quotient sign should be true');
    }

    #[test]
    fn test_neg() {
        // Test negation of positive number
        let a = FixedTrait::new(100, false);
        let neg_a = -a;
        assert(neg_a.mag == 100, 'neg mag should be preserved');
        assert(neg_a.sign == true, 'neg sign should be flipped');

        // Test negation of negative number
        let b = FixedTrait::new(100, true);
        let neg_b = -b;
        assert(neg_b.mag == 100, 'neg mag should be preserved');
        assert(neg_b.sign == false, 'neg sign should be flipped');

        // Test negation of zero
        let zero = FixedTrait::ZERO();
        let neg_zero = -zero;
        assert(neg_zero.mag == 0, 'neg zero mag should be 0');
        assert(neg_zero.sign == false, 'neg zero sign should be false');
    }

    #[test]
    fn test_exp() {
        // Test e^0 = 1
        let zero = FixedTrait::ZERO();
        let result = zero.exp();
        assert(result.mag == ONE_u128, 'e^0 should be 1');
        assert(result.sign == false, 'e^0 sign should be false');

        // Test e^1 ≈ 2.718
        let one = FixedTrait::ONE();
        let result = one.exp();
        // The exact value should be close to 2.718 * ONE_u128
        assert(result.mag > 2 * ONE_u128, 'e^1 should be > 2');
        assert(result.mag < 3 * ONE_u128, 'e^1 should be < 3');
        assert(result.sign == false, 'e^1 sign should be false');

        // Test e^-x = 1/e^x
        let neg_one = FixedTrait::new(ONE_u128, true);
        let result_neg = neg_one.exp();
        let expected = FixedTrait::ONE() / one.exp();
        // Allow small precision error
        let diff = if result_neg.mag > expected.mag {
            result_neg.mag - expected.mag
        } else {
            expected.mag - result_neg.mag
        };
        assert(diff < ONE_u128 / 1000000, 'e^-1 should be 1/e^1');
    }

    #[test]
    fn test_ln() {
        // Test ln(1) = 0
        let one = FixedTrait::ONE();
        let result = one.ln();
        // Allow small precision error
        assert(result.mag < ONE_u128 / 1000000, 'ln(1) should be close to 0');

        // Test ln(e) = 1
        let e = FixedTrait::ONE().exp();
        let result = e.ln();
        // Allow small precision error
        let diff = if result.mag > ONE_u128 {
            result.mag - ONE_u128
        } else {
            ONE_u128 - result.mag
        };
        assert(diff < ONE_u128 / 1000000, 'ln(e) should be close to 1');
    }

    #[test]
    fn test_pow() {
        // Test x^1 = x
        let x = FixedTrait::new(3 * ONE_u128, false);
        let one = FixedTrait::ONE();
        let result = pow(x, one);
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
    }

    #[test]
    fn test_sqrt() {
        // Test sqrt(4) = 2
        let four = FixedTrait::new(4 * ONE_u128, false);
        let result = sqrt(four);
        let two = FixedTrait::new(2 * ONE_u128, false);

        let diff = if result.mag > two.mag {
            result.mag - two.mag
        } else {
            two.mag - result.mag
        };
        assert(diff < ONE_u128 / 1000000, 'sqrt(4) should be 2');

        // Test sqrt(1) = 1
        let one = FixedTrait::ONE();
        let result = sqrt(one);

        let diff = if result.mag > one.mag {
            result.mag - one.mag
        } else {
            one.mag - result.mag
        };
        assert(diff < ONE_u128 / 1000000, 'sqrt(1) should be 1');
    }
}
