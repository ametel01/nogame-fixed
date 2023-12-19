use nogame_fixed::f128::core::{abs, add, div, exp, ln, mul, neg, sub};

const ONE_u128: u128 = 18446744073709551616_u128;

#[derive(Copy, Drop)]
struct Fixed {
    mag: u128,
    sign: bool
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
        return FixedTrait::new(mag * ONE_u128, sign);
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
