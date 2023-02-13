module contracts::lemon {
    use std::string::{Self, String};
    use sui::url::{Self, Url};
    use sui::object::{Self, UID, ID};
    use sui::tx_context::{Self, TxContext};
    use contracts::trait::{Self, Trait, Flavour};
    use contracts::item::{Self, Item, Items};
    use contracts::registry::{Self, Registry};
    use contracts::lemon;
    use sui::dynamic_field;
    use sui::transfer;
    use std::vector;
    use std::option;
    use sui::event::emit;

    // ------------------------ERRORS----------------------
    const EItemProhibbitedForAdding: u64 = 256;

    // ------------------------Structs---------------------
    struct Lemons {}

    struct Lemon has key, store {
        id: UID,
        url: Url,
        created: u64,
        traits: vector<Trait<String, String>>
    }

    struct Blueprint has store, drop {
        url: Url,
        created: u64,
        traits: vector<Trait<String, String>>
    }

    struct AdminCap has key {
        id: UID,
    }

    // ================Init=====================
    fun init(ctx: &mut TxContext) {
        let admin = AdminCap {
            id: object::new(ctx),
        };

        let lemon_registry = registry::create<Lemons, String, Flavour<String>>(ctx);
        lemon::populate_registry(&mut lemon_registry);
        let item_registry = registry::create<Items, String, Flavour<String>>(ctx);
        item::populate_registry(&mut item_registry);

        transfer::transfer(admin, tx_context::sender(ctx));
        transfer::share_object(lemon_registry);
        transfer::share_object(item_registry);
    }

    public fun populate_registry(registry: &mut Registry<Lemons, String, Flavour<String>>) {
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
        registry::append<Lemons, String, Flavour<String>>(registry, &group_name, *exo_top_flavours);

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
        registry::append<Lemons, String, Flavour<String>>(registry, &group_name, *exo_bot_flavours);

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
        registry::append<Lemons, String, Flavour<String>>(registry, &group_name, *feet_flavours);

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
        registry::append<Lemons, String, Flavour<String>>(registry, &group_name, *eyes_flavours);


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
        registry::append<Lemons, String, Flavour<String>>(registry, &group_name, *hands_flavours);

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
        registry::append<Lemons, String, Flavour<String>>(registry, &group_name, *head_flavours);

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
        registry::append<Lemons, String, Flavour<String>>(registry, &group_name, *teeth_flavours);
    }

    // ================Public EntryPoints=====================
    public entry fun create_lemon(registry: &mut Registry<Lemons, String, Flavour<String>>, ctx: &mut TxContext) {
        let lemon = new_lemon(registry, ctx);

        emit(LemonCreated {
            id: object::id(&lemon),
            created: lemon.created,
            url: lemon.url,
            traits: lemon.traits,
        });

        transfer::transfer(lemon, tx_context::sender(ctx))
    }

    // ================Admin=====================

    entry fun add_trait(
        _: &AdminCap,
        _registry: &mut Registry<Lemon, String, Flavour<String>>
    ) {}

    public entry fun add_item(
        lemon: &mut Lemon,
        item: Item<String, String>,
        ctx: &mut TxContext,
    ) {
        let traits = item::traits(&item);
        let trait = vector::pop_back(&mut traits);
        let trait_name = trait::name(&trait);
        let item_id = object::uid_to_inner(item::uid(&item));

        if (dynamic_field::exists_(&mut lemon.id, trait_name)) {
            remove_item(lemon, trait_name, ctx);
        };

        dynamic_field::add(&mut lemon.id, trait_name, item);
        emit(ItemAdded {
            lemon_id: object::uid_to_inner(&lemon.id),
            item_id,
        });
    }

    public entry fun remove_item(lemon: &mut Lemon, item_kind: String, ctx: &mut TxContext) {
        let item: Item<String, String> = dynamic_field::remove(&mut lemon.id, item_kind);
        let item_id = object::uid_to_inner(item::uid(&item));
        transfer::transfer(item, tx_context::sender(ctx));
        emit(ItemRemoved {
            lemon_id: object::uid_to_inner(&lemon.id),
            item_id,
        })
    }

    // ================Helpers=====================
    public fun uid<TraitName: copy, TraitFlavour: copy>(self: &Lemon): &UID {
        &self.id
    }

    public(friend) fun new_lemon(
        registry: &mut Registry<Lemons, String, Flavour<String>>,
        ctx: &mut TxContext,
    ): Lemon {
        registry::increment_counter(registry);

        let blueprint = new_blueprint(registry, ctx);
        from_blueprint(blueprint, ctx)
    }

    public fun new_flavour(name: vector<u8>, weight: u64): Flavour<String> {
        trait::new_flavour(string::utf8(name), option::some(weight))
    }

    public fun from_blueprint(blueprint: Blueprint, ctx: &mut TxContext): Lemon {
        Lemon {
            id: object::new(ctx),
            created: blueprint.created,
            url: blueprint.url,
            traits: blueprint.traits,
        }
    }

    public fun into_blueprint(lemon: Lemon): Blueprint {
        let Lemon { id, created, url, traits } = lemon;
        object::delete(id);

        Blueprint {
            created,
            url,
            traits
        }
    }

    public fun new_blueprint(
        registry: &mut Registry<Lemons, String, Flavour<String>>,
        ctx: &mut TxContext
    ): Blueprint {
        registry::increment_counter(registry);
        Blueprint {
            created: registry::counter(registry),
            url: url::new_unsafe_from_bytes(b"https://battlemon.com/assets/default-lemon.png"),
            traits: trait::generate_all<Lemons, String, String>(registry, ctx)
        }
    }

    // ====================Events================================================
    struct LemonCreated has copy, drop {
        id: ID,
        created: u64,
        url: Url,
        traits: vector<Trait<String, String>>
    }

    struct ItemAdded has copy, drop {
        lemon_id: ID,
        item_id: ID,
    }

    struct ItemRemoved has copy, drop {
        lemon_id: ID,
        item_id: ID,
    }

    // -----------------------TEST------------------------------------------------
    #[test_only]
    use sui::test_scenario;
    #[test_only]
    use contracts::test_helpers::{alice};
    #[test_only]
    use contracts::item::create_item;


    #[test]
    fun add_item_success() {
        let scenario_val = test_scenario::begin(alice());
        let scenario = &mut scenario_val;
        {
            let ctx = test_scenario::ctx(scenario);
            init(ctx);
        };
        test_scenario::next_tx(scenario, alice());
        {
            let lemon_registry = test_scenario::take_shared<Registry<Lemons, String, Flavour<String>>>(scenario);
            let item_registry = test_scenario::take_shared<Registry<Items, String, Flavour<String>>>(scenario);
            let ctx = test_scenario::ctx(scenario);
            create_lemon(&mut lemon_registry, ctx);
            create_item(&mut item_registry, ctx);
            test_scenario::return_shared(lemon_registry);
            test_scenario::return_shared(item_registry);
        };
        test_scenario::next_tx(scenario, alice());
        {
            let lemon = test_scenario::take_from_sender<Lemon>(scenario);
            let item = test_scenario::take_from_sender<Item<String, String>>(scenario);
            let item_registry = test_scenario::take_shared<Registry<Items, String, Flavour<String>>>(scenario);
            let ctx = test_scenario::ctx(scenario);
            add_item(&mut lemon, item, ctx);
            test_scenario::return_to_sender(scenario, lemon);
            test_scenario::return_shared(item_registry);
        };
        test_scenario::end(scenario_val);
    }

    #[test]
    fun replace_item_success() {
        let scenario_val = test_scenario::begin(alice());
        let scenario = &mut scenario_val;
        {
            let ctx = test_scenario::ctx(scenario);
            init(ctx);
        };
        test_scenario::next_tx(scenario, alice());
        {
            let lemon_registry = test_scenario::take_shared<Registry<Lemons, String, Flavour<String>>>(scenario);
            let item_registry = test_scenario::take_shared<Registry<Items, String, Flavour<String>>>(scenario);
            let ctx = test_scenario::ctx(scenario);
            create_lemon(&mut lemon_registry, ctx);
            create_item(&mut item_registry, ctx);
            test_scenario::return_shared(lemon_registry);
            test_scenario::return_shared(item_registry);
        };
        test_scenario::next_tx(scenario, alice());
        let item_id;
        let copycat_item_id;
        let trait_name;
        {
            let lemon = test_scenario::take_from_sender<Lemon>(scenario);
            let item = test_scenario::take_from_sender<Item<String, String>>(scenario);

            let traits = item::traits(&item);
            let trait = vector::pop_back(&mut traits);
            trait_name = trait::name(&trait);

            let item_registry = test_scenario::take_shared<Registry<Items, String, Flavour<String>>>(scenario);
            let ctx = test_scenario::ctx(scenario);
            let copycat_opt = trait::generate_by_name(&mut item_registry, &trait_name, ctx);
            let copycat_trait = option::extract(&mut copycat_opt);
            let traits = vector::singleton(copycat_trait);
            let copycat_item = item::from_traits(traits, ctx);

            item_id = item::uid(&item);
            copycat_item_id = item::uid(&copycat_item);

            add_item(&mut lemon, item, ctx);
            add_item(&mut lemon, copycat_item, ctx);


            test_scenario::return_to_sender(scenario, lemon);
            test_scenario::return_shared(item_registry);
        };
        test_scenario::next_tx(scenario, alice());
        {
            let lemon = test_scenario::take_from_sender<Lemon>(scenario);
            let item = test_scenario::take_from_sender<Item<String, String>>(scenario);
            dynamic_field::borrow(, trait_name);
        };
        test_scenario::end(scenario_val);
    }
}