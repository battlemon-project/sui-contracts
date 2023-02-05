module contracts::lemon {
    use std::string::{Self, String};
    use sui::url::{Self, Url};
    use sui::object::{Self, UID, ID};
    use sui::tx_context::{Self, TxContext};
    use contracts::trait::{Self, Trait, Flavour};
    use contracts::item::{Self, Item, Items};
    use contracts::registry::{Self, Registry};
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

        let registry = registry::create<Lemons, String, Flavour<String>>(ctx);
        populate_registry(&mut registry);

        transfer::transfer(admin, tx_context::sender(ctx));
        transfer::share_object(registry);
    }

    fun populate_registry(registry: &mut Registry<Lemons, String, Flavour<String>>) {
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
            new_flavour(b"ExoTop_Khaki", 192)
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
            new_flavour(b"ExoBot_Khaki", 128)
        );
        vector::push_back(
            exo_bot_flavours,
            new_flavour(b"ExoBot_Golden", 192)
        );
        vector::push_back(
            exo_bot_flavours,
            new_flavour(b"Exo_Military_Exoskeleton_MA01", 255)
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
            new_flavour(b"Feet_Khaki", 192)
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
            new_flavour(b"Hands_Khaki", 192)
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
            new_flavour(b"Teeth_Grillz_Diamond", 255)
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
        registry: &Registry<Items, String, Flavour<String>>,
        lemon: &mut Lemon,
        item: Item<String, String>
    ) {
        let traits = item::traits(&item);
        let trait = vector::pop_back(&mut traits);
        let trait_name = trait::name(&trait);
        let trait_flavour = trait::flavour(&trait);
        let flavour = new_flavour(*string::bytes(&trait_flavour), 0);
        assert!(registry::contains_value(registry, flavour), EItemProhibbitedForAdding);
        let item_id = object::uid_to_inner(item::uid(&item));
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
            url: url::new_unsafe_from_bytes(b"https://promo.battlemon.com/assets/default-lemon.png"),
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
}
// -----------------------TEST------------------------------------------------
//     #[test_only]
//     use std::vector;
//     #[test_only]
//     use sui::test_scenario;
//     #[test_only]
//     use contracts::test_helpers::{alice};
//     #[test_only]
//     use std::string::utf8;
//     use sui::event::emit;
//
//     #[test]
//     fun init_success() {
//         let scenario_val = test_scenario::begin(alice());
//         let scenario = &mut scenario_val;
//         let ctx = test_scenario::ctx(scenario);
//         {
//             init(ctx);
//         };
//         test_scenario::next_tx(scenario, alice());
//         {
//             let permitted = test_scenario::take_shared<Equipment>(scenario);
//             let admin = test_scenario::take_from_sender<AdminCap>(scenario);
//             test_scenario::return_shared(permitted);
//             test_scenario::return_to_sender(scenario, admin);
//         };
//         test_scenario::end(scenario_val);
//     }
//
//     #[test]
//     fun create_one_item_works() {
//         let ctx = tx_context::dummy();
//         let item = item::new(
//             utf8(b"foo"),
//             utf8(b"bar"),
//             &mut ctx
//         );
//
//         transfer::transfer(item, alice());
//     }
//
//     #[test]
//     #[expected_failure(abort_code = 256)]
//     fun add_prohibited_item_to_lemon_fail() {
//         let scenario_val = test_scenario::begin(alice());
//         let scenario = &mut scenario_val;
//         {
//             let ctx = test_scenario::ctx(scenario);
//             init(ctx);
//         };
//         test_scenario::next_tx(scenario, alice());
//         {
//             let ctx = test_scenario::ctx(scenario);
//             item::create(
//                 utf8(b"foo"),
//                 utf8(b"bar"),
//                 ctx
//             );
//             create_lemon(ctx);
//         };
//         test_scenario::next_tx(scenario, alice());
//         {
//             let permitted = test_scenario::take_shared<Equipment>(scenario);
//             let item = test_scenario::take_from_sender<Item>(scenario);
//             let lemon = test_scenario::take_from_sender<Lemon>(scenario);
//             lemon::add_item(&permitted, &mut lemon, item);
//             test_scenario::return_to_sender(scenario, lemon);
//             test_scenario::return_shared(permitted);
//         };
//         test_scenario::end(scenario_val);
//     }
//
//     #[test]
//     fun add_permitted_item_success() {
//         let scenario_val = test_scenario::begin(alice());
//         let scenario = &mut scenario_val;
//         {
//             let ctx = test_scenario::ctx(scenario);
//             init_helper(ctx);
//         };
//         test_scenario::next_tx(scenario, alice());
//         {
//             let ctx = test_scenario::ctx(scenario);
//             let flavour = utf8(b"bar");
//             item::create(
//                 utf8(b"foo"),
//                 flavour,
//                 ctx
//             );
//             lemon::create_lemon(ctx);
//             let admin = test_scenario::take_from_sender<AdminCap>(scenario);
//             let permitted = test_scenario::take_shared<Equipment>(scenario);
//             lemon::permit_new_item(
//                 &mut admin,
//                 &mut permitted,
//                 flavour
//             );
//             test_scenario::return_to_sender(scenario, admin);
//             test_scenario::return_shared(permitted);
//         };
//         test_scenario::next_tx(scenario, alice());
//         {
//             let permitted = test_scenario::take_shared<Equipment>(scenario);
//             let item = test_scenario::take_from_sender<Item>(scenario);
//             let lemon = test_scenario::take_from_sender<Lemon>(scenario);
//             lemon::add_item(&permitted, &mut lemon, item);
//             test_scenario::return_to_sender(scenario, lemon);
//             test_scenario::return_shared(permitted);
//         };
//         test_scenario::end(scenario_val);
//     }
//
//     #[test]
//     fun create_one_lemon_works() {
//         let scenario_val = test_scenario::begin(alice());
//         let scenario = &mut scenario_val;
//         let ctx = test_scenario::ctx(scenario);
//         {
//             lemon::create_lemon(ctx);
//         };
//         test_scenario::next_tx(scenario, alice());
//         {
//             let lemon = test_scenario::take_from_sender<Lemon>(scenario);
//             test_scenario::return_to_sender(scenario, lemon);
//         };
//         test_scenario::end(scenario_val);
//     }
//
//     #[test]
//     fun create_two_lemon_works() {
//         let scenario_val = test_scenario::begin(alice());
//         let scenario = &mut scenario_val;
//         let ctx = test_scenario::ctx(scenario);
//         {
//             lemon::create_lemon(ctx);
//             lemon::create_lemon(ctx);
//         };
//         test_scenario::next_tx(scenario, alice());
//         {
//             let lemons_amount = test_scenario::ids_for_sender<Lemon>(scenario);
//             assert!(vector::length(&lemons_amount) == 2, 0);
//         };
//         test_scenario::end(scenario_val);
//     }
// }