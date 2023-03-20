module monolith::trait {
    use monolith::registry::{Self, Registry};
    use monolith::iter::{Self};
    use monolith::randomness::{Self, Randomness};
    use std::vector;
    use std::option::{Self, Option};
    use std::hash;
    use std::string::{Self, String, utf8};
    use sui::tx_context::TxContext;


    /// ===========Constants============
    const MutationChance: u8 = 5;
    // 5/256 ~ 2%
    /// ===========ERRORS================
    const EParentsLengthMustBeEquals: u64 = 3001;
    const ERegistrySizeMustBeEqualParentTraitCount: u64 = 3002;

    struct Trait<TraitName, FlavourName> has store, copy, drop {
        name: TraitName,
        flavour: FlavourName,
    }

    struct Flavour<Name> has store, copy, drop {
        name: Name,
        weight: Option<u64>,
    }

    public fun name<TraitName: copy, FlavourName: copy>(self: &Trait<TraitName, FlavourName>): TraitName {
        self.name
    }

    public fun flavour<TraitName: copy, FlavourName: copy>(self: &Trait<TraitName, FlavourName>): FlavourName {
        self.flavour
    }

    fun new<TraitName, FlavourName>(
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

    public fun destroy_trait<TraitName, FlavourName>(self: Trait<TraitName, FlavourName>): (TraitName, FlavourName) {
        let Trait { name, flavour } = self;
        (name, flavour)
    }

    public fun generate_all<Witness: drop, TraitName: copy + drop, FlavourName: copy + drop>(
        registry: &mut Registry<Witness, TraitName, Flavour<FlavourName>>,
        randomness: &mut Randomness<Witness>,
        ctx: &mut TxContext,
    ): vector<Trait<TraitName, FlavourName>> {
        randomness::update(randomness, ctx);
        let source = randomness::source(randomness);
        let source_it = iter::from(source);
        let ret = vector::empty();

        let i = 0;
        while (i < registry::size(registry)) {
            let (trait, flavours) = registry::get_entry_by_idx(registry, i);
            let chance = iter::next_unwrap(&mut source_it);
            let flavours_it = iter::from(*flavours);

            while (iter::has_next(&flavours_it)) {
                let flavour = iter::next_unwrap(&mut flavours_it);
                let flavour_weight = option::borrow(&flavour.weight);

                if ((chance as u64) <= *flavour_weight) {
                    let ret_trait = new(*trait, flavour.name);
                    vector::push_back(&mut ret, ret_trait);
                    break
                };
            };

            i = i + 1;
        };

        ret
    }

    public fun generate_by_name<Witness: drop, TraitName: copy + drop, FlavourName: copy + drop>(
        registry: &mut Registry<Witness, TraitName, Flavour<FlavourName>>,
        randomness: &mut Randomness<Witness>,
        name: &TraitName,
        ctx: &mut TxContext
    ): Option<Trait<TraitName, FlavourName>> {
        randomness::update(randomness, ctx);
        let source = randomness::source(randomness);
        let ret = option::none<Trait<TraitName, FlavourName>>();
        let flavours_opt = registry::get<Witness, TraitName, Flavour<FlavourName>>(registry, name);

        if (option::is_none(&flavours_opt)) {
            return ret
        };

        let flavours = option::extract(&mut flavours_opt);

        handle_flavours(&flavours, &source, name)
    }

    public fun generate_by_idx<Witness: drop, TraitName: copy + drop, FlavourName: copy + drop>(
        registry: &mut Registry<Witness, TraitName, Flavour<FlavourName>>,
        randomness: &mut Randomness<Witness>,
        idx: u64,
        ctx: &mut TxContext
    ): Option<Trait<TraitName, FlavourName>> {
        randomness::update(randomness, ctx);
        let source = randomness::source(randomness);
        let (trait, flavours) = registry::get_entry_by_idx<Witness, TraitName, Flavour<FlavourName>>(registry, idx);

        handle_flavours(flavours, &source, trait)
    }

    // public fun mix<Witness: drop, TraitName: copy + drop, FlavourName: copy + drop>(
    //     admin: &Admin<Witness>,
    //     registry: &mut Registry<Witness, TraitName, Flavour<FlavourName>>,
    //     first_parent: &vector<Trait<TraitName, FlavourName>>,
    //     second_parent: &vector<Trait<TraitName, FlavourName>>,
    //     ctx: &mut TxContext
    // ): vector<Trait<TraitName, FlavourName>> {
    //     let parent_traits_count = vector::length(first_parent);
    //     assert!(
    //         parent_traits_count == vector::length(second_parent),
    //         EParentsLengthMustBeEquals
    //     );
    //     assert!(
    //         parent_traits_count == registry::size(registry),
    //         ERegistrySizeMustBeEqualParentTraitCount
    //     );
    //
    //     registry::update_seed(admin, registry, ctx);
    //     let seed = registry::seed_unwrap(registry);
    //
    //     let parent_traits_choice_seed = derive(seed, 0);
    //     let mutation_chance_seed = derive(seed, 1);
    //
    //     let ret = vector::empty();
    //     let i = 0;
    //     while (i < parent_traits_count) {
    //         let parent_trait_choice = vector::borrow(&parent_traits_choice_seed, i);
    //         let trait = *choose_parent(
    //             first_parent,
    //             second_parent,
    //             *parent_trait_choice,
    //             i
    //         );
    //
    //         let mutation_chance = vector::borrow(&mutation_chance_seed, i);
    //         if (*mutation_chance <= MutationChance) {
    //             let mutation = trait::generate_by_idx(admin, registry, i, ctx);
    //             trait = option::extract(&mut mutation);
    //         };
    //
    //         vector::push_back(&mut ret, trait);
    //         i = i + 1;
    //     };
    //
    //     ret
    // }

    fun handle_flavours<TraitName: copy + drop, FlavourName: copy + drop>(
        flavours: &vector<Flavour<FlavourName>>,
        weights: &vector<u8>,
        name: &TraitName,
    ): Option<Trait<TraitName, FlavourName>> {
        let ret = option::none();
        let flavours_it = iter::from(*flavours);
        let weights_it = iter::from(*weights);
        while (iter::has_next(&flavours_it)) {
            let chance = iter::next_unwrap(&mut weights_it);
            let flavour = iter::next_unwrap(&mut flavours_it);
            let flavour_weight = option::borrow(&flavour.weight);

            if ((chance as u64) <= *flavour_weight) {
                let trait = new(*name, flavour.name);
                return option::some(trait)
            };
        };

        ret
    }

    fun choose_parent<TraitName, FlavourName>(
        first_parent: &vector<Trait<TraitName, FlavourName>>,
        second_parent: &vector<Trait<TraitName, FlavourName>>,
        value: u8,
        idx: u64,
    ): &Trait<TraitName, FlavourName> {
        if (value <= 127) vector::borrow(first_parent, idx)
        else vector::borrow(second_parent, idx)
    }

    fun derive(seed: &vector<u8>, path: u8): vector<u8> {
        vector::push_back(&mut *seed, path);
        hash::sha3_256(*seed)
    }

    public fun create_url_to_media(self: &Trait<String, String>): String {
        let ret = utf8(b"https://battlemon.com/assets/128/Icon_");
        let suffix = utf8(b"_128.png");
        string::append(&mut ret, self.flavour);
        string::append(&mut ret, suffix);
        ret
    }
}