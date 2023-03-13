module monolith::randomness {
    use sui::object::{Self, UID};
    use std::vector;
    use sui::tx_context::TxContext;
    use std::hash;

    friend monolith::trait;

    struct Randomness<phantom Witness: drop> has key, store {
        id: UID,
        source: vector<u8>,
    }

    public fun new<Witness: drop>(_witness: Witness, ctx: &mut TxContext): Randomness<Witness> {
        let id = object::new(ctx);
        let source = hash::sha3_256(object::uid_to_bytes(&id));
        object::delete(id);

        Randomness<Witness> {
            id: object::new(ctx),
            source,
        }
    }

    public(friend) fun update<Witness: drop>(self: &mut Randomness<Witness>, ctx: &mut TxContext) {
        let id = object::new(ctx);
        vector::append(&mut self.source, object::uid_to_bytes(&id));

        self.source = hash::sha3_256(self.source);
        object::delete(id);
    }

    public fun source<Witness: drop>(self: &Randomness<Witness>): vector<u8> {
        self.source
    }
}