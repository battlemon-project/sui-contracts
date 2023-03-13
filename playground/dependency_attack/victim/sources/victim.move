module victim::victim {
    use sui::tx_context::TxContext;
    use dependency::foo::{Self, Foo};
    use dependency::admin::{Self, Admin};
    use sui::transfer;

    struct Witness has drop {}

    fun init(ctx: &mut TxContext) {
        let foo = foo::new(Witness {}, ctx);
        transfer::share_object(foo);
    }
}
