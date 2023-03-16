module monolith::random {
    use std::vector;
    use sui::object;
    use sui::math;
    use sui::tx_context::TxContext;

    const EBAD_RANGE: u64 = 0;
    const ETOO_FEW_BYTES: u64 = 1;
    const EDIVISOR_MUST_BE_NON_ZERO: u64 = 2;

    // Generates an integer from the range [min, max), not inclusive of max
    // bytes = vector<u8> with length of 20. However we only use the first 8 bytes
    public fun rng(min: u64, max: u64, ctx: &mut TxContext): u64 {
        assert!(max > min, EBAD_RANGE);

        let uid = object::new(ctx);
        let bytes = object::uid_to_bytes(&uid);
        object::delete(uid);

        let num = from_bytes(bytes);
        mod(num, max - min) + min
    }

    public fun from_bytes(bytes: vector<u8>): u64 {
        assert!(vector::length(&bytes) >= 8, ETOO_FEW_BYTES);

        let count: u8 = 0;
        let sum: u64 = 0;
        while (count < 8) {
            let value = *vector::borrow(&bytes, (count as u64));
            sum = sum + (value as u64) * math::pow(2, (7 - count) * 8);
            count = count + 1;
        };

        sum
    }

    public fun mod(x: u64, divisor: u64): u64 {
        assert!(divisor > 0, EDIVISOR_MUST_BE_NON_ZERO);

        let quotient = x / divisor;
        x - (quotient * divisor)
    }

    #[test]
    fun random_works() {
        use sui::tx_context;

        let ctx = &mut tx_context::dummy();
        let first = rng(0, 100, ctx);
        let second = rng(0, 100, ctx);
        assert!(first != second, 1);
    }
}
