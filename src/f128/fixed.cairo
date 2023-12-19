use nogame_fixed::f128::core::{add, div, exp, mul};

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

    // Constructors
    fn new(mag: u128, sign: bool) -> Fixed;
    fn new_unscaled(mag: u128, sign: bool) -> Fixed;

    // Math
    fn exp(self: Fixed) -> Fixed;
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

    fn exp(self: Fixed) -> Fixed {
        return exp(self);
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
