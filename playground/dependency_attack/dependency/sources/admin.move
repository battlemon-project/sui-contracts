module dependency::admin {
    use sui::object::UID;
    use sui::tx_context::TxContext;
    use sui::object;

    struct Admin<phantom Witness: drop> has key, store {
        id: UID,
    }

    public fun new<Witness: drop>(_witness: Witness, ctx: &mut TxContext): Admin<Witness> {
        Admin<Witness> {
            id: object::new(ctx),
        }
    }
}
