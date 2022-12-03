module contracts::registry {
    use sui::object::{Self, UID};
    use std::option::{Self, Option};
    use std::vector;
    use sui::tx_context::TxContext;
    use std::hash;
    use sui::vec_map::{Self, VecMap};

    // ==========Error=============
    const ERegistrySeedIsNone: u64 = 1001;

    struct Registry<phantom Kind, Key: copy + drop, Value: copy + drop> has key, store {
        id: UID,
        content: VecMap<Key, vector<Value>>,
        seed: Option<vector<u8>>,
        // count: Option<u64>,
    }

    public fun new<Kind, Key: copy + drop, Value: copy + drop>(
        id: UID,
        seed: Option<vector<u8>>,
    ): Registry<Kind, Key, Value> {
        Registry<Kind, Key, Value> {
            id,
            content: vec_map::empty(),
            seed,
        }
    }

    public fun create<Kind, Key: copy + drop, Value: copy + drop>(
        ctx: &mut TxContext,
    ): Registry<Kind, Key, Value> {
        let id = object::new(ctx);
        let seed = hash::sha3_256(object::uid_to_bytes(&id));

        new<Kind, Key, Value>(id, option::some(seed))
    }

    public fun add_or_insert<Kind, Key: copy + drop, Value: copy + drop>(
        registry: &mut Registry<Kind, Key, Value>,
        key: &Key,
        value: Value,
    ) {
        let content = &mut registry.content;
        let idx_opt = vec_map::get_idx_opt<Key, vector<Value>>(content, key);
        if (option::is_none(&idx_opt)) {
            let values = vector::singleton(value);
            vec_map::insert(content, *key, values);
        } else {
            let idx = option::extract(&mut idx_opt);
            let (_, values) = vec_map::get_entry_by_idx_mut(content, idx);
            vector::push_back(values, value);
        };
    }

    public fun append<Kind, Key: copy + drop, Value: copy + drop>(
        registry: &mut Registry<Kind, Key, Value>,
        key: &Key,
        values: vector<Value>,
    ) {
        let content = &mut registry.content;
        let idx_opt = vec_map::get_idx_opt<Key, vector<Value>>(content, key);
        if (option::is_none(&idx_opt)) {
            vec_map::insert(content, *key, values);
        } else {
            let idx = option::extract(&mut idx_opt);
            let (_, old_values) = vec_map::get_entry_by_idx_mut(content, idx);
            vector::append(old_values, values);
        };
    }

    public fun update_seed<Kind, Key: copy + drop, Value: copy + drop>(
        registry: &mut Registry<Kind, Key, Value>,
        ctx: &mut TxContext,
    ) {
        assert!(option::is_some(&registry.seed), ERegistrySeedIsNone);
        let id = object::new(ctx);
        let seed = option::borrow_mut(&mut registry.seed);
        vector::append(seed, object::uid_to_bytes(&id));
        registry.seed = option::some(hash::sha3_256(*seed));
        object::delete(id);
    }

    public fun get<Kind, Key: copy + drop, Value: copy + drop>(
        registry: &Registry<Kind, Key, Value>,
        key: &Key,
    ): Option<vector<Value>> {
        let content = &registry.content;
        let idx_opt = vec_map::get_idx_opt(content, key);
        if (option::is_none(&idx_opt)) {
            option::none<vector<Value>>()
        } else {
            let idx = option::extract(&mut idx_opt);
            let (_, values) = vec_map::get_entry_by_idx(content, idx);
            option::some(*values)
        }
    }

    public fun get_unwrap<Kind, Key: copy + drop, Value: copy + drop>(
        registry: &Registry<Kind, Key, Value>,
        key: &Key,
    ): vector<Value> {
        let ret = get(registry, key);
        option::extract(&mut ret)
    }

    public fun get_entry_by_idx<Kind, Key: copy + drop, Value: copy + drop>(
        registry: &Registry<Kind, Key, Value>,
        idx: u64,
    ): (&Key, &vector<Value>) {
        let content = &registry.content;
        vec_map::get_entry_by_idx(content, idx)
    }

    public fun size<Kind, Key: copy + drop, Value: copy + drop>(
        registry: &Registry<Kind, Key, Value>,
    ): u64 {
        let content = &registry.content;
        vec_map::size(content)
    }

    public fun seed<Kind, Key: copy + drop, Value: copy + drop>(
        registry: &Registry<Kind, Key, Value>,
    ): Option<vector<u8>> {
        registry.seed
    }

    public fun seed_unwrap<Kind, Key: copy + drop, Value: copy + drop>(
        registry: &mut Registry<Kind, Key, Value>,
    ): vector<u8> {
        option::extract(&mut registry.seed)
    }
}