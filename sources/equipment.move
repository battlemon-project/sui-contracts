module contracts::equipment {
    use sui::object::UID;
    use sui::vec_set::{Self, VecSet};
    use std::string::String;
    use sui::tx_context::TxContext;
    use sui::object;

    /// Must be create while initialization
    struct Equipment has key, store {
        id: UID,
        registry: VecSet<String>,
    }

    public fun new(ctx: &mut TxContext): Equipment {
        Equipment {
            id: object::new(ctx),
            registry: vec_set::empty(),
        }
    }

    public fun add(self: &mut Equipment, flavour: String) {
        vec_set::insert(&mut self.registry, flavour);
    }

    public fun contains(self: &Equipment, flavour: String): bool {
        vec_set::contains(&self.registry, &flavour)
    }
}
