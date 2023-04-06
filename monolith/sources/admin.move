module monolith::admin {
    use sui::object::{Self, UID};
    use sui::tx_context::TxContext;

    struct AdminCap<phantom Witness: drop> has key, store {
        id: UID,
    }

    public fun new<Witness: drop>(_witness: Witness, ctx: &mut TxContext): AdminCap<Witness> {
        AdminCap<Witness> {
            id: object::new(ctx),
        }
    }
}
