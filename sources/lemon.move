module contracts::item {
    use sui::object::{Self, UID};
    use sui::url::{Self, Url};
    use std::string::{String};
    use sui::tx_context::{Self, TxContext};
    use contracts::item;
    use sui::transfer;

    /// `kind` - fire_arm, cold_arm etc
    /// `flavour` - FireArms_Assault_Rifle_AA01
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


module contracts::lemon {
    use std::string::String;
    use contracts::lemon;
    use sui::object::{Self, UID};
    use sui::url::{Self, Url};
    use sui::tx_context::{Self as tx_ctx, TxContext};
    use sui::transfer;
    use sui::dynamic_field;
    use contracts::traits::{Self, Traits};
    use contracts::equipment::{Self, Equipment};
    use contracts::item::{Self, Item};

    // ------------------------ERRORS----------------------
    const EItemProhibbitedForAdding: u64 = 256;

    // ------------------------Structs---------------------

    struct Lemon has key {
        id: UID,
        url: Url,
        traits: Traits,
    }

    struct AdminCap has key {
        id: UID,
    }

    // --------------------functions-----------------------

    /// Temploray solution for the ability to test init function while this problem
    /// https://github.com/MystenLabs/sui/issues/6185 is not solved
    fun init_helper(ctx: &mut TxContext) {
        let admin = AdminCap {
            id: object::new(ctx),
        };

        let permitted_equipment = equipment::new(ctx);

        transfer::transfer(admin, tx_context::sender(ctx));
        transfer::share_object(permitted_equipment);
    }

    // todo: add one-time witness initialization
    fun init(ctx: &mut TxContext) {
        init_helper(ctx)
    }


    public fun new(ctx: &mut TxContext): Lemon {
        Lemon {
            id: object::new(ctx),
            url: url::new_unsafe_from_bytes(b"foo.bar"),
            traits: traits::new(ctx),
        }
    }

    // ---------------------ENTRY POINTS--------------------------
    public entry fun create(ctx: &mut TxContext) {
        let lemon = lemon::new(ctx);
        transfer::transfer(lemon, tx_ctx::sender(ctx))
    }

    // ---------------------ADMIN---------------------------------

    public entry fun permit_new_item(
        _: &mut AdminCap,
        equipment: &mut Equipment,
        item_flavour: String,
    ) {
        equipment::add(equipment, item_flavour);
    }

    // ----------------------Owner--------------------------------------
    public entry fun add_item(permitted: &Equipment, lemon: &mut Lemon, item: Item) {
        let flavour = item::flavour(&item);
        assert!(equipment::contains(permitted, flavour), EItemProhibbitedForAdding);
        let kind = item::kind(&item);
        dynamic_field::add(&mut lemon.id, kind, item);
    }

    public entry fun remove_item(lemon: &mut Lemon, item_kind: String, ctx: &mut TxContext) {
        let item: Item = dynamic_field::remove(&mut lemon.id, item_kind);
        transfer::transfer(item, tx_context::sender(ctx));
    }

    // -----------------------TEST------------------------------------------------
    #[test_only]
    use std::vector;
    #[test_only]
    use sui::test_scenario;
    #[test_only]
    use contracts::test_helpers::{alice};
    #[test_only]
    use std::string::utf8;
    use sui::tx_context;

    #[test]
    fun init_success() {
        let scenario_val = test_scenario::begin(alice());
        let scenario = &mut scenario_val;
        let ctx = test_scenario::ctx(scenario);
        {
            init_helper(ctx);
        };
        test_scenario::next_tx(scenario, alice());
        {
            let permitted = test_scenario::take_shared<Equipment>(scenario);
            let admin = test_scenario::take_from_sender<AdminCap>(scenario);
            test_scenario::return_shared(permitted);
            test_scenario::return_to_sender(scenario, admin);
        };
        test_scenario::end(scenario_val);
    }

    #[test]
    fun create_one_item_works() {
        let ctx = tx_ctx::dummy();
        let item = item::new(
            utf8(b"foo"),
            utf8(b"bar"),
            &mut ctx
        );

        transfer::transfer(item, alice());
    }

    #[test]
    #[expected_failure(abort_code = 256)]
    fun add_prohibited_item_to_lemon_fail() {
        let scenario_val = test_scenario::begin(alice());
        let scenario = &mut scenario_val;
        {
            let ctx = test_scenario::ctx(scenario);
            init_helper(ctx);
        };
        test_scenario::next_tx(scenario, alice());
        {
            let ctx = test_scenario::ctx(scenario);
            item::create(
                utf8(b"foo"),
                utf8(b"bar"),
                ctx
            );
            lemon::create(ctx);
        };
        test_scenario::next_tx(scenario, alice());
        {
            let permitted = test_scenario::take_shared<Equipment>(scenario);
            let item = test_scenario::take_from_sender<Item>(scenario);
            let lemon = test_scenario::take_from_sender<Lemon>(scenario);
            lemon::add_item(&permitted, &mut lemon, item);
            test_scenario::return_to_sender(scenario, lemon);
            test_scenario::return_shared(permitted);
        };
        test_scenario::end(scenario_val);
    }

    #[test]
    fun add_permitted_item_success() {
        let scenario_val = test_scenario::begin(alice());
        let scenario = &mut scenario_val;
        {
            let ctx = test_scenario::ctx(scenario);
            init_helper(ctx);
        };
        test_scenario::next_tx(scenario, alice());
        {
            let ctx = test_scenario::ctx(scenario);
            let flavour = utf8(b"bar");
            item::create(
                utf8(b"foo"),
                flavour,
                ctx
            );
            lemon::create(ctx);
            let admin = test_scenario::take_from_sender<AdminCap>(scenario);
            let permitted = test_scenario::take_shared<Equipment>(scenario);
            lemon::permit_new_item(
                &mut admin,
                &mut permitted,
                flavour
            );
            test_scenario::return_to_sender(scenario, admin);
            test_scenario::return_shared(permitted);
        };
        test_scenario::next_tx(scenario, alice());
        {
            let permitted = test_scenario::take_shared<Equipment>(scenario);
            let item = test_scenario::take_from_sender<Item>(scenario);
            let lemon = test_scenario::take_from_sender<Lemon>(scenario);
            lemon::add_item(&permitted, &mut lemon, item);
            test_scenario::return_to_sender(scenario, lemon);
            test_scenario::return_shared(permitted);
        };
        test_scenario::end(scenario_val);
    }

    #[test]
    fun create_one_lemon_works() {
        let scenario_val = test_scenario::begin(alice());
        let scenario = &mut scenario_val;
        let ctx = test_scenario::ctx(scenario);
        {
            lemon::create(ctx);
        };
        test_scenario::next_tx(scenario, alice());
        {
            let lemon = test_scenario::take_from_sender<Lemon>(scenario);
            test_scenario::return_to_sender(scenario, lemon);
        };
        test_scenario::end(scenario_val);
    }

    #[test]
    fun create_two_lemon_works() {
        let scenario_val = test_scenario::begin(alice());
        let scenario = &mut scenario_val;
        let ctx = test_scenario::ctx(scenario);
        {
            lemon::create(ctx);
            lemon::create(ctx);
        };
        test_scenario::next_tx(scenario, alice());
        {
            let lemons_amount = test_scenario::ids_for_sender<Lemon>(scenario);
            assert!(vector::length(&lemons_amount) == 2, 0);
        };
        test_scenario::end(scenario_val);
    }
}