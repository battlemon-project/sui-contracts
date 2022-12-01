module contracts::trait {
    use contracts::registry::Registry;
    use sui::tx_context::TxContext;
    use contracts::registry;
    use std::vector;
    use contracts::trait;
    use std::option::{Self, Option};

    struct Trait<TraitName, FlavourName> has store, copy, drop {
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

    public fun from_registry<Kind, TraitName: copy + drop, FlavourName: copy + drop>(
        registry: &mut Registry<Kind, TraitName, Flavour<FlavourName>>,
        ctx: &mut TxContext
    ): vector<Trait<TraitName, FlavourName>> {
        registry::update_seed(registry, ctx);
        let seed_opt = registry::seed(registry);
        let seed = option::borrow(&seed_opt);
        let ret = vector::empty();

        let i = 0;
        while (i < registry::size(registry)) {
            let (trait, flavours) = registry::get_entry_by_idx(registry, i);

            let j = 0;
            while (j < vector::length(flavours)) {
                let chance = vector::borrow(seed, i);
                let flavour = vector::borrow(flavours, j);
                let flavour_weight = option::borrow(&flavour.weight);

                if ((*chance as u64) <= *flavour_weight) {
                    let ret_trait = trait::new_trait(*trait, flavour.name);
                    vector::push_back(&mut ret, ret_trait);
                    break
                };
                j = j + 1;
            };
            i = i + 1;
        };

        ret
    }


    public fun from_registry_by_name<Kind, TraitName: copy + drop, FlavourName: copy + drop>(
        registry: &mut Registry<Kind, TraitName, Flavour<FlavourName>>,
        name: &TraitName,
        ctx: &mut TxContext
    ): Option<Trait<TraitName, FlavourName>> {
        registry::update_seed(registry, ctx);
        let seed_opt = registry::seed(registry);
        let seed = option::borrow(&seed_opt);
        let ret = option::none<Trait<TraitName, FlavourName>>();

        let trait_group_opt = registry::get<Kind, TraitName, Flavour<FlavourName>>(registry, name);

        if (option::is_none(&trait_group_opt)) {
            return ret
        };

        let flavours = option::borrow(&trait_group_opt);

        let i = 0;
        while (i < vector::length(flavours)) {
            let chance = vector::borrow(seed, i);
            let flavour = vector::borrow(flavours, i);
            let flavour_weight = option::borrow(&flavour.weight);

            if ((*chance as u64) <= *flavour_weight) {
                return option::some(trait::new_trait(*name, flavour.name))
            };

            i = i + 1;
        };

        ret
    }
}