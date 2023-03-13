module dependency::foo {
    use sui::object::{Self, UID};
    use sui::tx_context::TxContext;
    use dependency::admin::{Self, Admin};


    struct Foo<phantom T> has key, store {
        id: UID,
        value: u64,
    }

    public fun new<T: drop>(witness: T, ctx: &mut TxContext): (Admin<T>, Foo<T>) {
        let foo = Foo<T> {
            id: object::new(ctx),
            value: 0,
        };

        let admin = admin::new(witness, ctx);

        (admin, foo)
    }

    public fun mutate<T: drop>(admin: &Admin<T>, foo: &mut Foo<T>, value: u64) {
        foo.value = value;
    }
}
