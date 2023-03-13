module monolith::admin {
    use sui::object::UID;
    use sui::tx_context::TxContext;
    use sui::object;

    struct AdminCap<phantom Witness: drop> has key, store {
        id: UID,
    }

    public fun new<Witness: drop>(_witness: Witness, ctx: &mut TxContext): AdminCap<Witness> {
        AdminCap<Witness> {
            id: object::new(ctx),
        }
    }
}
