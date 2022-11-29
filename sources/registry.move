module contracts::registry {
    use sui::object::UID;
    use std::option::Option;
    use std::vector;
    use sui::object;
    use std::option;
    use sui::tx_context::TxContext;
    use std::hash;
    use contracts::trait_group::TraitsGroup;
    use contracts::trait_group;

    // ==========Error=============
    const ERegistrySeedIsNone: u64 = 1001;

    /// registry for arbitrary type
    struct Registry<phantom Kind, Name, Flavour> has key, store {
        id: UID,
        traits_groups: vector<TraitsGroup<Name, Flavour>>,
        seed: Option<vector<u8>>
    }

    public fun new<Kind, Name, Flavour>(
        id: UID,
        seed: Option<vector<u8>>
    ): Registry<Kind, Name, Flavour> {
        Registry<Kind, Name, Flavour> {
            id,
            traits_groups: vector::empty(),
            seed,
        }
    }

    public fun add<Kind, Name: store + drop + copy, Flavour: store + drop + copy>(
        registry: &mut Registry<Kind, Name, Flavour>,
        name: Name,
        flavours: vector<Flavour>
    ) {
        let group = trait_group::new(name, flavours);
        vector::push_back(&mut registry.traits_groups, group);
    }

    public fun update_seed<Kind, Name: store + drop + copy, Flavour: store + drop + copy>(
        registry: &mut Registry<Kind, Name, Flavour>,
        ctx: &mut TxContext,
    ) {
        assert!(option::is_some(&registry.seed), ERegistrySeedIsNone);
        let id = object::new(ctx);
        let seed = option::borrow_mut(&mut registry.seed);
        vector::append(seed, object::uid_to_bytes(&id));
        registry.seed = option::some(hash::sha3_256(*seed));
        object::delete(id);
    }

    public fun borrow_traits_groups<Kind, Name: store + drop + copy, Flavour: store + drop + copy>(
        registry: &Registry<Kind, Name, Flavour>,
    ): &vector<TraitsGroup<Name, Flavour>> {
        &registry.traits_groups
    }

    public fun borrow_seed<Kind, Name: store + drop + copy, Flavour: store + drop + copy>(
        registry: &Registry<Kind, Name, Flavour>,
    ): &vector<u8> {
        option::borrow(&registry.seed)
    }
}