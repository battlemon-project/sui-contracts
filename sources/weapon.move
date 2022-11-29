module contracts::weapon {
    use std::string::{Self, String};
    use std::vector;
    use sui::object::UID;
    use sui::url::Url;
    use contracts::lemon::AdminCap;
    use contracts::registry::{Self, Registry};
    use contracts::trait::{Self, Trait};

    // ================Types=====================
    struct Weapon<Kind, Flavour> has key, store {
        id: UID,
        url: Url,
        traits: vector<Trait<Kind, Flavour>>,
    }

    struct Flavour has store, drop, copy {
        name: String,
        weight: u8,
    }

    // ================Admin=====================
    entry fun add_trait(
        _: &AdminCap,
        registry: &mut Registry<Weapon<String, Flavour>, String, Flavour>,
        raw_kind: vector<u8>,
        raw_flavours: vector<vector<u8>>
    ) {
        let flavours = into_flavours(raw_flavours);
        let kind = string::utf8(raw_kind);
        registry::add(registry, kind, flavours)
    }


    // ================Helpers=====================
    fun into_flavours(raw_flavours: vector<vector<u8>>): vector<Flavour> {
        let flavours = vector::empty();

        let idx = 0;
        while (idx < vector::length(&raw_flavours)) {
            let raw_flavour = vector::borrow(&raw_flavours, idx);
            let (weight, rest) = split_last(*raw_flavour);
            let name = string::utf8(rest);
            let flavour = Flavour { name, weight };
            vector::push_back(&mut flavours, flavour);

            idx = idx + 1;
        };

        flavours
    }

    fun split_last(raw_flavour: vector<u8>): (u8, vector<u8>) {
        (vector::pop_back(&mut raw_flavour), raw_flavour)
    }
}
