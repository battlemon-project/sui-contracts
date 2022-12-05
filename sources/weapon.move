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
    use contracts::iter;
    use sui::coin::Coin;
    use contracts::juice::JUICE;
    use sui::coin;

    // ================Errors=====================
    const EParentsKindsAreNotSame: u64 = 2001;
    const EJuiceAmountNotCorrect: u64 = 2002;

    // ================Types=====================
    // Registry Key
    struct Weapons {}

    // Family Statuses
    struct Any {}

    struct Parent {}

    struct Child {}

    // Weapon key for indexing in registry
    struct WeaponKey<Kind, TraitName> has copy, store, drop {
        kind: Kind,
        trait: TraitName,
    }

    // Weapon NFT token
    struct Weapon<phantom FamilyStatus, Kind, Rarity, TraitName, FlavourName> has key, store {
        id: UID,
        url: Url,
        traits: vector<Trait<TraitName, FlavourName>>,
        kind: Kind,
        rarity: Rarity,
        mix_cost: u64,
        children: u64,
    }

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
        let registry = registry::create(ctx);
        populate_submachine_gun_registry(&mut registry);
        transfer::share_object(registry);
    }

    fun populate_submachine_gun_registry(
        registry: &mut Registry<Weapons, WeaponKey<String, String>, Flavour<String>>
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

        registry::append<Weapons, WeaponKey<String, String>, Flavour<String>>(
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

        registry::append<Weapons, WeaponKey<String, String>, Flavour<String>>(
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
        registry::append<Weapons, WeaponKey<String, String>, Flavour<String>>(
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

        registry::append<Weapons, WeaponKey<String, String>, Flavour<String>>(
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
        registry::append<Weapons, WeaponKey<String, String>, Flavour<String>>(
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

        registry::append<Weapons, WeaponKey<String, String>, Flavour<String>>(
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
        registry::append<Weapons, WeaponKey<String, String>, Flavour<String>>(
            registry,
            &weapon_key,
            *butt_flavours
        );
    }


    // ================Public Entrypoints=====================
    public entry fun create_parent_weapon(
        registry: &mut Registry<Weapons, WeaponKey<String, String>, Flavour<String>>,
        kind: String,
        ctx: &mut TxContext
    ) {
        let weapon: Weapon<Parent, String, String, String, String>
            = new_weapon(registry, kind, ctx);

        transfer::transfer(weapon, tx_context::sender(ctx))
    }

    public entry fun mix_weapons(
        registry: &mut Registry<Weapons, String, Flavour<String>>,
        first_parent: &mut Weapon<Parent, String, String, String, String>,
        second_parent: &mut Weapon<Parent, String, String, String, String>,
        coin: Coin<JUICE>,
        ctx: &mut TxContext,
    ) {
        let mix_price = (first_parent.mix_cost + second_parent.mix_cost);
        assert!(coin::value(&coin) == mix_price, EJuiceAmountNotCorrect);

        let weapon: Weapon<Child, String, String, String, String> = mix(
            registry,
            first_parent,
            second_parent,
            ctx
        );

        first_parent.mix_cost = first_parent.mix_cost + 1;
        first_parent.children = first_parent.children + 1;
        second_parent.mix_cost = second_parent.mix_cost + 1;
        second_parent.children = second_parent.children + 1;

        transfer::transfer(weapon, tx_context::sender(ctx));
        transfer::transfer(coin, tx_context::sender(ctx));
    }

    // ================Helpers=====================
    fun new_weapon<FamilyStatus, Kind: copy + drop, TraitName: copy + drop, FlavourName: copy + drop>(
        registry: &mut Registry<Weapons, WeaponKey<Kind, TraitName>, Flavour<FlavourName>>,
        kind: Kind,
        ctx: &mut TxContext,
    ): Weapon<FamilyStatus, Kind, String, TraitName, FlavourName> {
        let traits = trait::generate_all(registry, ctx);
        let traits = filter_map_traits(&mut traits, kind);

        Weapon {
            id: object::new(ctx),
            url: url::new_unsafe_from_bytes(b"foo.bar"),
            rarity: string::utf8(b"normal"),
            traits,
            kind,
            mix_cost: 3,
            children: 0,
        }
    }

    fun filter_map_traits<Kind: copy + drop, TraitName: copy + drop, FlavourName: copy + drop>(
        traits: &mut vector<Trait<WeaponKey<Kind, TraitName>, FlavourName>>,
        kind: Kind,
    ): vector<Trait<TraitName, FlavourName>> {
        let ret = vector::empty();
        let traits_it = iter::from(*traits);
        while (iter::has_next(&traits_it)) {
            let trait = iter::next_unwrap(&mut traits_it);
            let (weapon_key, flavour) = trait::destroy_trait(trait);
            let WeaponKey<Kind, TraitName> { kind: weapon_kind, trait } = weapon_key;
            if (weapon_kind == kind) {
                vector::push_back(&mut ret, trait::new_trait(trait, flavour))
            };
        };

        ret
    }

    fun mix<Kind: copy + drop, TraitName: copy + drop, FlavourName: copy + drop>(
        registry: &mut Registry<Weapons, TraitName, Flavour<FlavourName>>,
        first_parent: &mut Weapon<Parent, Kind, String, TraitName, FlavourName>,
        second_parent: &mut Weapon<Parent, Kind, String, TraitName, FlavourName>,
        ctx: &mut TxContext,
    ): Weapon<Child, Kind, String, TraitName, FlavourName> {
        let weapon_kind = first_parent.kind;
        assert!(weapon_kind == second_parent.kind, EParentsKindsAreNotSame);

        let traits = trait::mix<Weapons, TraitName, FlavourName>(
            registry,
            &first_parent.traits,
            &second_parent.traits,
            ctx
        );

        Weapon {
            id: object::new(ctx),
            url: url::new_unsafe_from_bytes(b"foo"),
            traits,
            kind: weapon_kind,
            rarity: string::utf8(b"hybrid"),
            mix_cost: 0,
            children: 0,
        }
    }

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
