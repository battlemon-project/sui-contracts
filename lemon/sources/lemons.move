module lemon::lemons {
    use std::string::{Self, String};
    use std::vector;
    use std::option;
    use sui::url::{Self, Url};
    use sui::object::{Self, UID, ID};
    use sui::tx_context::{Self, TxContext};
    use sui::transfer;
    use sui::event::emit;
    use sui::coin::{Self, Coin};
    use sui::sui::SUI;
    use monolith::registry::{Self, Registry};
    use monolith::admin::AdminCap;
    use monolith::trait::{Self, Trait, Flavour};
    use monolith::randomness::{Self, Randomness};
    use lemon::mint_config::{Self, MintConfig};
    use sui::balance::{Self, Balance};

    friend lemon::lemon_pool;
    // ------------------------ERRORS----------------------
    const EItemProhibbitedForAdding: u64 = 0;

    // ------------------------Structs---------------------
    struct LEMONS has drop {}

    struct Lemon has key, store {
        id: UID,
        url: Url,
        genesis: String,
        traits: vector<Trait<String, String>>
    }

    struct Blueprint has store, drop {
        url: Url,
        genesis: String,
        traits: vector<Trait<String, String>>
    }

    struct Treasury has key {
        id: UID,
        balance: Balance<SUI>,
    }

    // ================Init=====================
    fun init(ctx: &mut TxContext) {
        let (admin, lemon_registry)
            = registry::new<LEMONS, String, Flavour<String>>(LEMONS {}, ctx);
        populate_registry(&admin, &mut lemon_registry);
        transfer::transfer(admin, tx_context::sender(ctx));
        transfer::share_object(lemon_registry);

        let treasure = Treasury {
            id: object::new(ctx),
            balance: balance::zero(),
        };
        transfer::share_object(treasure);

        let mint_config = mint_config::new<LEMONS>(ctx);
        transfer::share_object(mint_config);

        let randomness = randomness::new(LEMONS {}, ctx);
        transfer::share_object(randomness);
    }

    fun populate_registry(admin: &AdminCap<LEMONS>, registry: &mut Registry<LEMONS, String, Flavour<String>>) {
        // exo_top
        let exo_top_flavours = &mut vector::empty<Flavour<String>>();
        vector::push_back(
            exo_top_flavours,
            new_flavour(b"ExoTop_Snowwhite", 64)
        );
        vector::push_back(
            exo_top_flavours,
            new_flavour(b"ExoTop_Steel", 128)
        );
        vector::push_back(
            exo_top_flavours,
            new_flavour(b"ExoTop_Hacky", 192)
        );
        vector::push_back(
            exo_top_flavours,
            new_flavour(b"ExoTop_Golden", 255)
        );
        let group_name = string::utf8(b"exo_top");
        registry::append<LEMONS, String, Flavour<String>>(admin, registry, &group_name, *exo_top_flavours);

        // exo_bot
        let exo_bot_flavours = &mut vector::empty<Flavour<String>>();
        vector::push_back(
            exo_bot_flavours,
            new_flavour(b"ExoBot_Snowwhite", 64)
        );
        vector::push_back(
            exo_bot_flavours,
            new_flavour(b"ExoBot_Hacky", 128)
        );
        vector::push_back(
            exo_bot_flavours,
            new_flavour(b"ExoBot_Golden", 192)
        );
        vector::push_back(
            exo_bot_flavours,
            new_flavour(b"ExoBot_Steel", 255)
        );
        let group_name = string::utf8(b"exo_bot");
        registry::append<LEMONS, String, Flavour<String>>(admin, registry, &group_name, *exo_bot_flavours);

        // feet
        let feet_flavours = &mut vector::empty<Flavour<String>>();
        vector::push_back(
            feet_flavours,
            new_flavour(b"Feet_Snowwhite", 64)
        );
        vector::push_back(
            feet_flavours,
            new_flavour(b"Feet_Steel", 128)
        );
        vector::push_back(
            feet_flavours,
            new_flavour(b"Feet_Military", 192)
        );
        vector::push_back(
            feet_flavours,
            new_flavour(b"Feet_Golden", 255)
        );
        let group_name = string::utf8(b"feet");
        registry::append<LEMONS, String, Flavour<String>>(admin, registry, &group_name, *feet_flavours);

        // eyes
        let eyes_flavours = &mut vector::empty<Flavour<String>>();
        vector::push_back(
            eyes_flavours,
            new_flavour(b"Eyes_Blue", 64)
        );
        vector::push_back(
            eyes_flavours,
            new_flavour(b"Eyes_Green", 128)
        );
        vector::push_back(
            eyes_flavours,
            new_flavour(b"Eyes_Alien", 192)
        );
        vector::push_back(
            eyes_flavours,
            new_flavour(b"Eyes_Zombie", 255)
        );
        let group_name = string::utf8(b"eyes");
        registry::append<LEMONS, String, Flavour<String>>(admin, registry, &group_name, *eyes_flavours);


        // hands
        let hands_flavours = &mut vector::empty<Flavour<String>>();
        vector::push_back(
            hands_flavours,
            new_flavour(b"Hands_Snowwhite", 64)
        );
        vector::push_back(
            hands_flavours,
            new_flavour(b"Hands_Steel", 128)
        );
        vector::push_back(
            hands_flavours,
            new_flavour(b"Hands_Yellow_Plastic", 192)
        );
        vector::push_back(
            hands_flavours,
            new_flavour(b"Hands_Golden", 255)
        );
        let group_name = string::utf8(b"hands");
        registry::append<LEMONS, String, Flavour<String>>(admin, registry, &group_name, *hands_flavours);

        // head
        let head_flavours = &mut vector::empty<Flavour<String>>();
        vector::push_back(
            head_flavours,
            new_flavour(b"Head_Fresh_Lemon", 64)
        );
        vector::push_back(
            head_flavours,
            new_flavour(b"Head_Zombie", 128)
        );
        vector::push_back(
            head_flavours,
            new_flavour(b"Head_Clementine", 192)
        );
        vector::push_back(
            head_flavours,
            new_flavour(b"Head_Lime", 255)
        );
        let group_name = string::utf8(b"head");
        registry::append<LEMONS, String, Flavour<String>>(admin, registry, &group_name, *head_flavours);

        //teeth
        let teeth_flavours = &mut vector::empty<Flavour<String>>();
        vector::push_back(
            teeth_flavours,
            new_flavour(b"Teeth_Grga", 51)
        );
        vector::push_back(
            teeth_flavours,
            new_flavour(b"Teeth_Hollywood", 102)
        );
        vector::push_back(
            teeth_flavours,
            new_flavour(b"Teeth_Oldstyle", 153)
        );
        vector::push_back(
            teeth_flavours,
            new_flavour(b"Teeth_Sharp", 204)
        );
        vector::push_back(
            teeth_flavours,
            new_flavour(b"Teeth_Grillz_Silver", 255)
        );
        let group_name = string::utf8(b"teeth");
        registry::append<LEMONS, String, Flavour<String>>(admin, registry, &group_name, *teeth_flavours);
    }

    // ================EntryPoints=====================
    public entry fun mint(
        registry: &mut Registry<LEMONS, String, Flavour<String>>,
        randomness: &mut Randomness<LEMONS>,
        treasure: &mut Treasury,
        mint_config: &mut MintConfig<LEMONS>,
        sui: Coin<SUI>,
        ctx: &mut TxContext,
    ) {
        mint_config::check_sui_for_mint(mint_config, &sui);
        mint_config::check_supply(mint_config);
        mint_config::check_minted_for_account(mint_config, ctx);

        if (!mint_config::is_whitelisted(mint_config, ctx)) {
            mint_config::check_mint_lock(mint_config);
        };

        put_in_treasure(treasure, sui);
        mint_config::increment_minted(mint_config);
        mint_config::increment_minted_for_account(mint_config, ctx);

        let lemon = new(registry, randomness, string::utf8(b"SUI"), ctx);
        emit(LemonCreated {
            id: object::id(&lemon),
            url: lemon.url,
            traits: lemon.traits,
        });
        transfer::transfer(lemon, tx_context::sender(ctx))
    }

    public entry fun take_from_treasure(
        _: AdminCap<LEMONS>,
        treasure: &mut Treasury,
        amount: u64,
        ctx: &mut TxContext
    ) {
        let sui = coin::take(&mut treasure.balance, amount, ctx);
        transfer::transfer(sui, tx_context::sender(ctx));
    }

    // ================Helpers=====================
    public fun uid(self: &Lemon): &UID {
        &self.id
    }

    fun put_in_treasure(treasure: &mut Treasury, sui: Coin<SUI>) {
        let balance = coin::into_balance(sui);
        balance::join(&mut treasure.balance, balance);
    }

    fun new(
        registry: &mut Registry<LEMONS, String, Flavour<String>>,
        randomness: &mut Randomness<LEMONS>,
        genesis: String,
        ctx: &mut TxContext,
    ): Lemon {
        let blueprint = new_blueprint(registry, randomness, genesis, ctx);
        from_blueprint(blueprint, ctx)
    }

    fun new_flavour(name: vector<u8>, weight: u64): Flavour<String> {
        trait::new_flavour(string::utf8(name), option::some(weight))
    }

    public(friend) fun from_blueprint(blueprint: Blueprint, ctx: &mut TxContext): Lemon {
        Lemon {
            id: object::new(ctx),
            url: blueprint.url,
            genesis: blueprint.genesis,
            traits: blueprint.traits,
        }
    }

    public fun into_blueprint(lemon: Lemon): Blueprint {
        let Lemon { id, url, genesis, traits } = lemon;
        object::delete(id);

        Blueprint {
            url,
            genesis,
            traits
        }
    }

    public fun new_blueprint(
        registry: &mut Registry<LEMONS, String, Flavour<String>>,
        randomness: &mut Randomness<LEMONS>,
        genesis: String,
        ctx: &mut TxContext,
    ): Blueprint {
        Blueprint {
            url: url::new_unsafe_from_bytes(b"https://battlemon.com/assets/default-lemon.png"),
            genesis,
            traits: trait::generate_all<LEMONS, String, String>(registry, randomness, ctx),
        }
    }

    // ====================Events================================================
    struct LemonCreated has copy, drop {
        id: ID,
        url: Url,
        traits: vector<Trait<String, String>>
    }


    // -----------------------TEST------------------------------------------------
    // #[test_only]
    // use sui::test_scenario;
    // #[test_only]
    // use sui::test_utils::{assert_eq};


    // #[test]
    // fun add_item_success() {
    //     let scenario_val = test_scenario::begin(@alice);
    //     let scenario = &mut scenario_val;
    //     {
    //         let ctx = test_scenario::ctx(scenario);
    //         init(ctx);
    //     };
    //     test_scenario::next_tx(scenario, @alice);
    //     {
    //         let admin = test_scenario::take_from_sender<Admin<LEMONS>>(scenario);
    //         let lemon_registry = test_scenario::take_shared<Registry<LEMONS, String, Flavour<String>>>(scenario);
    //         let ctx = test_scenario::ctx(scenario);
    //         create_lemon(&admin, &mut lemon_registry, ctx);
    //         test_scenario::return_shared(lemon_registry);
    //     };
    //     test_scenario::next_tx(scenario, @alice);
    //     {
    //         let lemon = test_scenario::take_from_sender<Lemon>(scenario);
    //         test_scenario::return_to_sender(scenario, lemon);
    //     };
    //     test_scenario::end(scenario_val);
    // }

    // #[test]
    // fun replace_item_success() {
    //     let scenario_val = test_scenario::begin(alice());
    //     let scenario = &mut scenario_val;
    //     {
    //         let ctx = test_scenario::ctx(scenario);
    //         init(ctx);
    //     };
    //     test_scenario::next_tx(scenario, alice());
    //     {
    //         let lemon_registry = test_scenario::take_shared<Registry<Lemons, String, Flavour<String>>>(scenario);
    //         let item_registry = test_scenario::take_shared<Registry<Items, String, Flavour<String>>>(scenario);
    //         let ctx = test_scenario::ctx(scenario);
    //         create_lemon(&mut lemon_registry, ctx);
    //         create_item(&mut item_registry, ctx);
    //         test_scenario::return_shared(lemon_registry);
    //         test_scenario::return_shared(item_registry);
    //     };
    //     test_scenario::next_tx(scenario, alice());
    //
    //     let trait_name;
    //     {
    //         let item = test_scenario::take_from_sender<Item<String, String>>(scenario);
    //         let traits = item::traits(&item);
    //         let trait = vector::pop_back(&mut traits);
    //         trait_name = trait::name(&trait);
    //         let item_registry = test_scenario::take_shared<Registry<Items, String, Flavour<String>>>(scenario);
    //         let ctx = test_scenario::ctx(scenario);
    //         let copycat_opt = trait::generate_by_name(&mut item_registry, &trait_name, ctx);
    //         let copycat_trait = option::extract(&mut copycat_opt);
    //         let copycat_traits = vector::singleton(copycat_trait);
    //         let copycat_item = item::from_traits(copycat_traits, ctx);
    //
    //         transfer::transfer(copycat_item, alice());
    //         test_scenario::return_to_sender(scenario, item);
    //         test_scenario::return_shared(item_registry);
    //     };
    //     test_scenario::next_tx(scenario, alice());
    //     let copycat_item_id;
    //     {
    //         let lemon = test_scenario::take_from_sender<Lemon>(scenario);
    //         let item = test_scenario::take_from_sender<Item<String, String>>(scenario);
    //         let copycat_item = test_scenario::take_from_sender(scenario);
    //         copycat_item_id = object::id(&copycat_item);
    //         let item_registry = test_scenario::take_shared<Registry<Items, String, Flavour<String>>>(scenario);
    //         let ctx = test_scenario::ctx(scenario);
    //         add_item(&mut lemon, item, ctx);
    //         add_item(&mut lemon, copycat_item, ctx);
    //
    //         test_scenario::return_to_sender(scenario, lemon);
    //         test_scenario::return_shared(item_registry);
    //     };
    //     test_scenario::next_tx(scenario, alice());
    //     {
    //         let lemon = test_scenario::take_from_sender<Lemon>(scenario);
    //         let item = test_scenario::take_from_sender<Item<String, String>>(scenario);
    //         let added_item
    //             = dynamic_field::borrow<String, Item<String, String>>(uid(&lemon), trait_name);
    //         if (&item == added_item) {
    //             abort 1
    //         };
    //         let added_item_id = object::id(added_item);
    //         assert_eq(copycat_item_id, added_item_id);
    //
    //         test_scenario::return_to_sender(scenario, lemon);
    //         test_scenario::return_to_sender(scenario, item);
    //     };
    //     test_scenario::end(scenario_val);
    // }
}