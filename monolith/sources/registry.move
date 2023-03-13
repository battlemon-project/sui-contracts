module monolith::registry {
    use sui::object::{Self, UID};
    use std::option::{Self, Option};
    use std::vector;
    use sui::tx_context::TxContext;
    use sui::vec_map::{Self, VecMap};
    use monolith::admin::{Self, AdminCap};


    struct Registry<phantom Witness: drop, Key: copy + drop, Value: copy + drop> has key, store {
        id: UID,
        content: VecMap<Key, vector<Value>>,
    }

    public fun new<Witness: drop, Key: copy + drop, Value: copy + drop>(
        witness: Witness,
        ctx: &mut TxContext,
    ): (AdminCap<Witness>, Registry<Witness, Key, Value>) {
        let admin = admin::new(witness, ctx);
        let registry = Registry<Witness, Key, Value> {
            id: object::new(ctx),
            content: vec_map::empty()
        };

        (admin, registry)
    }

    public fun add_or_insert<Witness: drop, Key: copy + drop, Value: copy + drop>(
        _admin: &AdminCap<Witness>,
        registry: &mut Registry<Witness, Key, Value>,
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

    public fun append<Witness: drop, Key: copy + drop, Value: copy + drop>(
        _admin: &AdminCap<Witness>,
        registry: &mut Registry<Witness, Key, Value>,
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

    public fun get<Witness: drop, Key: copy + drop, Value: copy + drop>(
        registry: &Registry<Witness, Key, Value>,
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

    public fun get_unwrap<Witness: drop, Key: copy + drop, Value: copy + drop>(
        registry: &Registry<Witness, Key, Value>,
        key: &Key,
    ): vector<Value> {
        let ret = get(registry, key);
        option::extract(&mut ret)
    }

    public fun get_entry_by_idx<Witness: drop, Key: copy + drop, Value: copy + drop>(
        registry: &Registry<Witness, Key, Value>,
        idx: u64,
    ): (&Key, &vector<Value>) {
        let content = &registry.content;
        vec_map::get_entry_by_idx(content, idx)
    }

    public fun size<Witness: drop, Key: copy + drop, Value: copy + drop>(
        registry: &Registry<Witness, Key, Value>,
    ): u64 {
        let content = &registry.content;
        vec_map::size(content)
    }

    public fun contains_value<Witness: drop, Key: copy + drop, Value: copy + drop>(
        registry: &Registry<Witness, Key, Value>,
        value: Value,
    ): bool {
        let idx = 0;
        while (idx < size(registry)) {
            let (_, values) = get_entry_by_idx(registry, idx);
            if (vector::contains(values, &value)) {
                return true
            };
            idx = idx + 1;
        };

        false
    }
}