module contracts::weapon {
    use std::string::{Self, String};
    use sui::object::{Self, UID};
    use sui::url::{Self, Url};
    use contracts::trait::{Self, Trait, Flavour};
    use sui::tx_context::{Self, TxContext};
    use contracts::registry::{Self, Registry};
    use std::vector;
    use contracts::lemon::new_flavour;
    use sui::transfer;

    // ================Types=====================
    struct WeaponTraits {}

    struct WeaponKinds {}

    // ================Family Statuses====================
    struct Any {}

    struct Parent {}

    struct Child {}

    // ===============WeaponKind==========================
    // struct SubmachineGun {}
    // struct MachinePistol {}
    // struct MachineGun {}
    // struct MachinePistol {}
    struct WeaponKey<Kind, TraitName> has copy, store, drop {
        kind: Kind,
        trait: TraitName,
    }

    struct Weapon<phantom FamilyStatus, Kind> has key, store {
        id: UID,
        url: Url,
        traits: vector<Trait<String, String>>,
        kind: Kind
        // mix_cost: u64,
        // children: u64,
    }

    // struct Flavour has store, drop, copy {
    //     name: String,
    //     weight: u8,
    // }

    // ================Admin=====================
    // entry fun add_trait(
    //     _: &AdminCap,
    //     registry: &mut Registry<Weapon, String, Flavour>,
    //     raw_kind: vector<u8>,
    //     raw_flavours: vector<vector<u8>>
    // ) {
    //     let flavours = into_flavours(raw_flavours);
    //     let kind = string::utf8(raw_kind);
    //     registry::add(registry, kind, flavours)
    // }

    // ================Init=====================
    fun init(ctx: &mut TxContext) {
        let registry = registry::create<WeaponTraits, WeaponKey<String, String>, Flavour<String>>(ctx);
        populate_submachine_gun_registry(&mut registry);
        transfer::share_object(registry);
    }

    fun populate_submachine_gun_registry(
        registry: &mut Registry<WeaponTraits, WeaponKey<String, String>, Flavour<String>>
    ) {
        let kind = string::utf8(b"submachine_gun");

        // receiver
        let receiver_flavours = &mut vector::empty<Flavour<String>>();
        vector::push_back(
            receiver_flavours,
            new_flavour(b"receiver1", 51)
        );
        vector::push_back(
            receiver_flavours,
            new_flavour(b"receiver2", 102)
        );
        vector::push_back(
            receiver_flavours,
            new_flavour(b"receiver3", 153)
        );
        vector::push_back(
            receiver_flavours,
            new_flavour(b"receiver4", 204)
        );
        vector::push_back(
            receiver_flavours,
            new_flavour(b"receiver5", 255)
        );

        let weapon_key = WeaponKey {
            trait: string::utf8(b"receiver"),
            kind,
        };

        registry::append<WeaponTraits, WeaponKey<String, String>, Flavour<String>>(
            registry,
            &weapon_key,
            *receiver_flavours
        );

        // magazine
        let magazine_flavours = &mut vector::empty<Flavour<String>>();
        vector::push_back(
            magazine_flavours,
            new_flavour(b"magazine1", 51)
        );
        vector::push_back(
            magazine_flavours,
            new_flavour(b"magazine2", 102)
        );
        vector::push_back(
            magazine_flavours,
            new_flavour(b"magazine3", 153)
        );
        vector::push_back(
            magazine_flavours,
            new_flavour(b"magazine4", 204)
        );
        vector::push_back(
            magazine_flavours,
            new_flavour(b"magazine5", 255)
        );

        let weapon_key = WeaponKey {
            trait: string::utf8(b"magazine"),
            kind,
        };

        registry::append<WeaponTraits, WeaponKey<String, String>, Flavour<String>>(
            registry,
            &weapon_key,
            *magazine_flavours
        );

        // barrel
        let barrel_flavours = &mut vector::empty<Flavour<String>>();
        vector::push_back(
            barrel_flavours,
            new_flavour(b"barrel1", 51)
        );
        vector::push_back(
            barrel_flavours,
            new_flavour(b"barrel2", 102)
        );
        vector::push_back(
            barrel_flavours,
            new_flavour(b"barrel3", 153)
        );
        vector::push_back(
            barrel_flavours,
            new_flavour(b"barrel4", 204)
        );
        vector::push_back(
            barrel_flavours,
            new_flavour(b"barrel5", 255)
        );

        let weapon_key = WeaponKey {
            trait: string::utf8(b"barrel"),
            kind,
        };
        registry::append<WeaponTraits, WeaponKey<String, String>, Flavour<String>>(
            registry,
            &weapon_key,
            *barrel_flavours
        );
        // muzzle
        let muzzle_flavours = &mut vector::empty<Flavour<String>>();
        vector::push_back(
            muzzle_flavours,
            new_flavour(b"muzzle1", 51)
        );
        vector::push_back(
            muzzle_flavours,
            new_flavour(b"muzzle2", 102)
        );
        vector::push_back(
            muzzle_flavours,
            new_flavour(b"muzzle3", 153)
        );
        vector::push_back(
            muzzle_flavours,
            new_flavour(b"muzzle4", 204)
        );
        vector::push_back(
            muzzle_flavours,
            new_flavour(b"muzzle5", 255)
        );

        let weapon_key = WeaponKey {
            trait: string::utf8(b"muzzle"),
            kind,
        };

        registry::append<WeaponTraits, WeaponKey<String, String>, Flavour<String>>(
            registry,
            &weapon_key,
            *muzzle_flavours
        );

        // sight
        let sight_flavours = &mut vector::empty<Flavour<String>>();
        vector::push_back(
            sight_flavours,
            new_flavour(b"sight1", 51)
        );
        vector::push_back(
            sight_flavours,
            new_flavour(b"sight2", 102)
        );
        vector::push_back(
            sight_flavours,
            new_flavour(b"sight3", 153)
        );
        vector::push_back(
            sight_flavours,
            new_flavour(b"sight4", 204)
        );
        vector::push_back(
            sight_flavours,
            new_flavour(b"sight5", 255)
        );

        let weapon_key = WeaponKey {
            trait: string::utf8(b"sight"),
            kind,
        };
        registry::append<WeaponTraits, WeaponKey<String, String>, Flavour<String>>(
            registry,
            &weapon_key,
            *sight_flavours
        );

        // grip
        let grip_flavours = &mut vector::empty<Flavour<String>>();
        vector::push_back(
            grip_flavours,
            new_flavour(b"grip1", 51)
        );
        vector::push_back(
            grip_flavours,
            new_flavour(b"grip2", 102)
        );
        vector::push_back(
            grip_flavours,
            new_flavour(b"grip3", 153)
        );
        vector::push_back(
            grip_flavours,
            new_flavour(b"grip4", 204)
        );
        vector::push_back(
            grip_flavours,
            new_flavour(b"grip5", 255)
        );
        let weapon_key = WeaponKey {
            trait: string::utf8(b"grip"),
            kind,
        };

        registry::append<WeaponTraits, WeaponKey<String, String>, Flavour<String>>(
            registry,
            &weapon_key,
            *grip_flavours
        );

        // butt
        let butt_flavours = &mut vector::empty<Flavour<String>>();
        vector::push_back(
            butt_flavours,
            new_flavour(b"butt1", 51)
        );
        vector::push_back(
            butt_flavours,
            new_flavour(b"butt2", 102)
        );
        vector::push_back(
            butt_flavours,
            new_flavour(b"butt3", 153)
        );
        vector::push_back(
            butt_flavours,
            new_flavour(b"butt4", 204)
        );
        vector::push_back(
            butt_flavours,
            new_flavour(b"butt5", 255)
        );

        let weapon_key = WeaponKey {
            kind,
            trait: string::utf8(b"butt"),
        };
        registry::append<WeaponTraits, WeaponKey<String, String>, Flavour<String>>(
            registry,
            &weapon_key,
            *butt_flavours
        );
    }


    // ================Public Entrypoints=====================
    public entry fun create_parent_weapon(
        registry: &mut Registry<WeaponTraits, String, Flavour<String>>,
        ctx: &mut TxContext
    ) {
        let weapon = new_weapon<Parent, String>(registry, ctx);
        transfer::transfer(weapon, tx_context::sender(ctx))
    }

    // public entry fun mix_weapons(
    //     registry: &mut Registry<WeaponTraits, String, Flavour<String>>,
    //     first: &mut Weapon<Parent, String>,
    //     second: &mut Weapon<Parent, String>,
    //     ctx: &mut TxContext,
    // ) {
    //     let weapon = mix(registry, first, second, ctx);
    //     transfer::transfer(weapon, tx_context::sender(ctx))
    // }

    // ================Helpers=====================
    fun new_weapon<FamilyStatus, Kind>(
        registry: &mut Registry<WeaponTraits, String, Flavour<String>>,
        ctx: &mut TxContext,
    ): Weapon<FamilyStatus, vector<u8>> {
        let kind = b"";
        Weapon {
            id: object::new(ctx),
            url: url::new_unsafe_from_bytes(b"foo.bar"),
            traits: trait::from_registry<WeaponTraits, String, String>(registry, ctx),
            kind,
        }
    }

    // fun mix(
    //     registry: &mut Registry<WeaponTraits, String, Flavour<String>>,
    //     first: &mut Weapon<Parent>,
    //     second: &mut Weapon<Parent>,
    //     ctx: &mut TxContext,
    // ): Weapon<Child> {
    //     registry::update_seed(registry, ctx);
    //     let seed = registry::borrow_seed(registry);
    // }

    fun split_last(raw_flavour: vector<u8>): (u8, vector<u8>) {
        (vector::pop_back(&mut raw_flavour), raw_flavour)
    }

    // fun into_flavours(raw_flavours: vector<vector<u8>>): vector<Flavour> {
    //     let flavours = vector::empty();
    //
    //     let idx = 0;
    //     while (idx < vector::length(&raw_flavours)) {
    //         let raw_flavour = vector::borrow(&raw_flavours, idx);
    //         let (weight, rest) = split_last(*raw_flavour);
    //         let name = string::utf8(rest);
    //         let flavour = Flavour { name, weight };
    //         vector::push_back(&mut flavours, flavour);
    //
    //         idx = idx + 1;
    //     };
    //
    //     flavours
    // }
}
