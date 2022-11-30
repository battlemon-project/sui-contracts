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
    struct Weapon has key, store {
        id: UID,
        url: Url,
        traits: vector<Trait<String, String>>,
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

    fun init(ctx: &mut TxContext) {
        let registry = registry::create<Weapon, String, Flavour<String>>(ctx);
        populate_registry(&mut registry);
        transfer::share_object(registry);
    }

    fun new_weapon(
        registry: &mut Registry<Weapon, String, Flavour<String>>,
        ctx: &mut TxContext,
    ): Weapon {
        Weapon {
            id: object::new(ctx),
            url: url::new_unsafe_from_bytes(b"foo.bar"),
            traits: trait::from_registry<Weapon, String, String>(registry, ctx),
        }
    }


    // ================Helpers=====================

    fun populate_registry(registry: &mut Registry<Weapon, String, Flavour<String>>) {
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
        let group_name = string::utf8(b"receiver");
        registry::add<Weapon, String, Flavour<String>>(registry, group_name, *receiver_flavours);
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
        let group_name = string::utf8(b"magazine");
        registry::add<Weapon, String, Flavour<String>>(registry, group_name, *magazine_flavours);
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
        let group_name = string::utf8(b"barrel");
        registry::add<Weapon, String, Flavour<String>>(registry, group_name, *barrel_flavours);
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
        let group_name = string::utf8(b"muzzle");
        registry::add<Weapon, String, Flavour<String>>(registry, group_name, *muzzle_flavours);
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
        let group_name = string::utf8(b"sight");
        registry::add<Weapon, String, Flavour<String>>(registry, group_name, *sight_flavours);
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
        let group_name = string::utf8(b"grip");
        registry::add<Weapon, String, Flavour<String>>(registry, group_name, *grip_flavours);
    }

    // ================Public EntryPoints=====================
    public entry fun create_weapon(registry: &mut Registry<Weapon, String, Flavour<String>>, ctx: &mut TxContext) {
        let weapon = new_weapon(registry, ctx);
        transfer::transfer(weapon, tx_context::sender(ctx))
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

    fun split_last(raw_flavour: vector<u8>): (u8, vector<u8>) {
        (vector::pop_back(&mut raw_flavour), raw_flavour)
    }
}
