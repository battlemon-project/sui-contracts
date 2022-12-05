module contracts::error {
    const ELemonError: u64 = 1000;
    const EWeaponError: u64 = 2000;
    const ETraitError: u64 = 3000;

    public fun lemon_error(error_code: u64): u64 {
        ELemonError + error_code
    }

    public fun weapon_error(error_code: u64): u64 {
        ELemonError + error_code
    }

    public fun trait_error(error_code: u64): u64 {
        ELemonError + error_code
    }
}
