module contracts::trait {
    use contracts::registry::Registry;
    use sui::tx_context::TxContext;
    use contracts::registry;
    use std::vector;
    use contracts::group;
    use contracts::trait;
    use std::option::{Self, Option};

    struct Trait<TraitName, FlavourName> has store {
        name: TraitName,
        flavour: FlavourName,
    }

    struct Flavour<Name> has store, copy, drop {
        name: Name,
        weight: Option<u64>,
    }

    public fun new_trait<TraitName, FlavourName>(
        name: TraitName,
        flavour: FlavourName
    ): Trait<TraitName, FlavourName> {
        Trait {
            name,
            flavour
        }
    }

    public fun new_flavour<Name>(name: Name, weight: Option<u64>): Flavour<Name> {
        Flavour<Name> {
            name,
            weight
        }
    }

    public fun from_registry<Kind, TraitName: copy, FlavourName: copy>(
        registry: &mut Registry<Kind, TraitName, Flavour<FlavourName>>,
        ctx: &mut TxContext
    ): vector<Trait<TraitName, FlavourName>> {
        registry::update_seed(registry, ctx);
        let ret = vector::empty();
        let traits_groups = registry::borrow_traits_groups(registry);
        let seed = registry::borrow_seed(registry);

        let i = 0;
        while (i < vector::length(traits_groups)) {
            let traits_group = vector::borrow(traits_groups, i);
            let flavours = group::entries<TraitName, Flavour<FlavourName>>(traits_group);

            let j = 0;
            while (j < vector::length(flavours)) {
                let chance = vector::borrow(seed, i);
                let flavour = vector::borrow(flavours, j);
                let flavour_weight = option::borrow(&flavour.weight);

                if ((*chance as u64) <= *flavour_weight) {
                    let traits_group_name = group::name(traits_group);
                    let ret_trait = trait::new_trait(*traits_group_name, flavour.name);
                    vector::push_back(&mut ret, ret_trait);
                    break
                };

                j = j + 1;
            };

            i = i + 1;
        };

        ret
    }
}