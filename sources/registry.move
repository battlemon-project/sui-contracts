module contracts::registry {
    use sui::object::UID;
    use std::option::Option;
    use std::vector;
    use sui::object;
    use std::option;
    use sui::tx_context::TxContext;
    use std::hash;
    use contracts::group::{Self, Group};

    // ==========Error=============
    const ERegistrySeedIsNone: u64 = 1001;

    struct Registry<phantom Kind, Name, Entry> has key, store {
        id: UID,
        groups: vector<Group<Name, Entry>>,
        seed: Option<vector<u8>>,
        // count: Option<u64>,
    }

    public fun new<Kind, Name, Entry>(
        id: UID,
        seed: Option<vector<u8>>,
    ): Registry<Kind, Name, Entry> {
        Registry<Kind, Name, Entry> {
            id,
            groups: vector::empty(),
            seed,
        }
    }

    public fun create<Kind, Name, Entry>(ctx: &mut TxContext): Registry<Kind, Name, Entry> {
        let id = object::new(ctx);
        let seed = hash::sha3_256(object::uid_to_bytes(&id));

        new<Kind, Name, Entry>(id, option::some(seed))
    }

    public fun add<Kind, Name: store, Entry: store>(
        registry: &mut Registry<Kind, Name, Entry>,
        name: Name,
        flavours: vector<Entry>
    ) {
        let group = group::new(name, flavours);
        vector::push_back(&mut registry.groups, group);
    }

    public fun update_seed<Kind, Name, Entry>(
        registry: &mut Registry<Kind, Name, Entry>,
        ctx: &mut TxContext,
    ) {
        assert!(option::is_some(&registry.seed), ERegistrySeedIsNone);
        let id = object::new(ctx);
        let seed = option::borrow_mut(&mut registry.seed);
        vector::append(seed, object::uid_to_bytes(&id));
        registry.seed = option::some(hash::sha3_256(*seed));
        object::delete(id);
    }

    public fun borrow_traits_groups<Kind, Name, Entry>(
        registry: &Registry<Kind, Name, Entry>,
    ): &vector<Group<Name, Entry>> {
        &registry.groups
    }

    public fun borrow_seed<Kind, Name, Entry>(
        registry: &Registry<Kind, Name, Entry>,
    ): &vector<u8> {
        option::borrow(&registry.seed)
    }
}