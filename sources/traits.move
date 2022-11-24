/// add dynamic fields for traits and functions for setup trait and drop chances
module contracts::traits {
    use contracts::random::rng;
    use sui::tx_context::TxContext;
    use std::string::{String, utf8};

    /// exo
    const ExoSteelExoSkeletonAA01: vector<u8> = b"Exo_Steel_Exoskeleton_AA01";
    const ExoSnowwhiteExoSkeletonAA02: vector<u8> = b"Exo_Snowwhite_Exoskeleton_AA02";
    /// eyes
    const EyesBlueAA01: vector<u8> = b"Eyes_Blue_AA01";
    const EyesGreenAA02: vector<u8> = b"Eyes_Green_AA02";
    /// head
    const HeadFreshLemonAA01: vector<u8> = b"Head_Fresh_Lemon_AA01";
    const HeadZombieZA01: vector<u8> = b"Head_Zombie_ZA01";
    /// face
    const FaceNinjaBalaclavaNA01: vector<u8> = b"Face_Ninja_Balaclava_NA_01";
    const FaceGasMaskMA01: vector<u8> = b"Face_Gas_Mask_MA01";
    const FaceCowboyScarfCA01: vector<u8> = b"Face_Cowboy_Scarf_CA01";
    const FaceSunglassesRA01: vector<u8> = b"Face_Sunglasses_RA01";
    /// teeth
    const TeethGrgaAA02: vector<u8> = b"Teeth_Grga_AA02";
    const TeethHollywoodAA01: vector<u8> = b"Teeth_Hollywood_AA01";
    const TeethOldstyleAA04: vector<u8> = b"Teeth_Oldstyle_AA04";
    const TeethSharpAA03: vector<u8> = b"Teeth_Sharp_AA03";

    struct Traits has store, drop {
        exo: String,
        eyes: String,
        head: String,
        face: String,
        teeth: String,
    }

    public fun new(ctx: &mut TxContext): Traits {
        Traits {
            exo: rand_exo(ctx),
            eyes: rand_eyes(ctx),
            head: rand_head(ctx),
            face: rand_face(ctx),
            teeth: rand_teeth(ctx),
        }
    }

    fun rand_exo(ctx: &mut  TxContext): String {
        let value = rng(0, 100, ctx);
        let ret = if (value <= 49) {
            ExoSnowwhiteExoSkeletonAA02
        } else {
            ExoSteelExoSkeletonAA01
        };

        utf8(ret)
    }

    fun rand_eyes(ctx: &mut  TxContext): String {
        let value = rng(0, 100, ctx);
        let ret = if (value <= 49) {
            EyesBlueAA01
        } else {
            EyesGreenAA02
        };

        utf8(ret)
    }

    fun rand_head(ctx: &mut  TxContext): String {
        let value = rng(0, 100, ctx);
        let ret = if (value <= 80) {
            HeadFreshLemonAA01
        } else {
            HeadZombieZA01
        };

        utf8(ret)
    }

    fun rand_face(ctx: &mut  TxContext): String {
        let value = rng(0, 100, ctx);
        let ret = if (value <= 24) {
            FaceSunglassesRA01
        } else if (value <= 50) {
            FaceGasMaskMA01
        } else if (value <= 75) {
            FaceNinjaBalaclavaNA01
        } else {
            FaceCowboyScarfCA01
        };

        utf8(ret)
    }

    fun rand_teeth(ctx: &mut  TxContext): String {
        let value = rng(0, 100, ctx);
        let ret = if (value <= 24) {
            TeethGrgaAA02
        } else if (value <= 50) {
            TeethHollywoodAA01
        } else if (value <= 75) {
            TeethOldstyleAA04
        } else {
            TeethSharpAA03
        };

        utf8(ret)
    }
}

#[test_only]
module contracts::tests {
    use contracts::traits;
    use sui::test_scenario;
    use contracts::test_helpers::alice;

    #[test]
    fun create_new_traits() {
        let scenario = test_scenario::begin(alice());
        let ctx = test_scenario::ctx(&mut scenario);
        let first_traits = traits::new(ctx);
        let second_traits = traits::new(ctx);
        assert!(first_traits != second_traits, 0);
        test_scenario::end(scenario);
    }
}
