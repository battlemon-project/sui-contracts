module attacker::attacker {
    use dependency::foo::{Self, Foo};
    use victim::victim::Witness;
    use dependency::admin::Admin;
    use sui::tx_context::TxContext;

    fun init(ctx: &mut TxContext) {
        let (admin, foo) = foo::new(Witness {}, ctx);
    }

    public entry fun spoil_foo(admin: &Admin<Witness>, foo: &mut Foo<Witness>) {
        foo::mutate(admin, foo, 666);
    }
}