module contracts::item {
    use sui::object::{Self, UID};
    use sui::url::{Self, Url};
    use std::string::{String};
    use sui::tx_context::{Self, TxContext};
    use contracts::item;
    use sui::transfer;

    struct Item has key, store {
        id: UID,
        url: Url,
        kind: String,
        flavour: String,
    }

    public entry fun create(kind: String, flavour: String, ctx: &mut TxContext) {
        let item = item::new(kind, flavour, ctx);
        transfer::transfer(item, tx_context::sender(ctx));
    }

    public fun new(kind: String, flavour: String, ctx: &mut TxContext): Item {
        Item {
            id: object::new(ctx),
            url: url::new_unsafe_from_bytes(b"foo"),
            kind,
            flavour,
        }
    }

    public fun kind(self: &Item): String {
        self.kind
    }

    public fun flavour(self: &Item): String {
        self.flavour
    }
}
