module contracts::lemon {
    use std::string::{Self, String};
    use sui::url::{Self, Url};
    use sui::object::{Self, UID, ID};
    use sui::tx_context::{Self, TxContext};
    use contracts::trait::{Self, Trait, Flavour};
    use contracts::equipment::{Self, Equipment};
    use contracts::item::{Self, Item};
    use contracts::registry::{Self, Registry};
    use sui::dynamic_field;
    use sui::transfer;
    use std::vector;
    use std::option;


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
        // exo
        let exo_flavours = &mut vector::empty<Flavour<String>>();
        vector::push_back(
            exo_flavours,
            new_flavour(b"Exo_Snowwhite_Exoskeleton_AA02", 85)
        );
        vector::push_back(
            exo_flavours,
            new_flavour(b"Exo_Steel_Exoskeleton_AA01", 170)
        );
        vector::push_back(
            exo_flavours,
            new_flavour(b"Exo_Military_Exoskeleton_MA01", 255)
        );
        let group_name = string::utf8(b"exo");
        registry::append<Lemons, String, Flavour<String>>(registry, &group_name, *exo_flavours);

        // eyes
        let eyes_flavours = &mut vector::empty<Flavour<String>>();
        vector::push_back(
            eyes_flavours,
            new_flavour(b"Eyes_Blue_AA01", 85)
        );
        vector::push_back(
            eyes_flavours,
            new_flavour(b"Eyes_Green_AA02", 170)
        );
        vector::push_back(
            eyes_flavours,
            new_flavour(b"Eyes_Zombie_ZA01", 255)
        );
        let group_name = string::utf8(b"eyes");
        registry::append<Lemons, String, Flavour<String>>(registry, &group_name, *eyes_flavours);

        // head
        let head_flavours = &mut vector::empty<Flavour<String>>();
        vector::push_back(
            head_flavours,
            new_flavour(b"Head_Fresh_Lemon_AA01", 64)
        );
        vector::push_back(
            head_flavours,
            new_flavour(b"Head_Zombie_ZA01", 128)
        );
        vector::push_back(
            head_flavours,
            new_flavour(b"Head_Clementine_AA02", 192)
        );
        vector::push_back(
            head_flavours,
            new_flavour(b"Head_Lime_AA03", 255)
        );
        let group_name = string::utf8(b"head");
        registry::append<Lemons, String, Flavour<String>>(registry, &group_name, *head_flavours);

        //teeth
        let teeth_flavours = &mut vector::empty<Flavour<String>>();
        vector::push_back(
            teeth_flavours,
            new_flavour(b"Teeth_Grga_AA02", 51)
        );
        vector::push_back(
            teeth_flavours,
            new_flavour(b"Teeth_Hollywood_AA01", 102)
        );
        vector::push_back(
            teeth_flavours,
            new_flavour(b"Teeth_Oldstyle_AA04", 153)
        );
        vector::push_back(
            teeth_flavours,
            new_flavour(b"Teeth_Sharp_AA03", 204)
        );
        vector::push_back(
            teeth_flavours,
            new_flavour(b"Teeth_Grillz_Silver_RA01", 255)
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

    entry fun permit_new_item(
        _: &AdminCap,
        equipment: &mut Equipment,
        item_flavour: String,
    ) {
        equipment::add(equipment, item_flavour);
    }

    entry fun add_trait(
        _: &AdminCap,
        _registry: &mut Registry<Lemon, String, Flavour<String>>
    ) {}

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

    // ================Helpers=====================
    fun new_lemon(
        registry: &mut Registry<Lemons, String, Flavour<String>>,
        ctx: &mut TxContext,
    ): Lemon {
        registry::increment_counter(registry);

        Lemon {
            id: object::new(ctx),
            created: registry::counter(registry),
            url: url::new_unsafe_from_bytes(b"https://promo.battlemon.com/assets/default-lemon.png"),
            traits: trait::generate_all<Lemons, String, String>(registry, ctx)
        }
    }

    public fun new_flavour(name: vector<u8>, weight: u64): Flavour<String> {
        trait::new_flavour(string::utf8(name), option::some(weight))
    }

    // ====================Events================================================
    struct LemonCreated has copy, drop {
        id: ID,
        created: u64,
        url: Url,
        traits: vector<Trait<String, String>>
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
    use sui::event::emit;

    #[test]
    fun init_success() {
        let scenario_val = test_scenario::begin(alice());
        let scenario = &mut scenario_val;
        let ctx = test_scenario::ctx(scenario);
        {
            init(ctx);
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
        let ctx = tx_context::dummy();
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
            init(ctx);
        };
        test_scenario::next_tx(scenario, alice());
        {
            let ctx = test_scenario::ctx(scenario);
            item::create(
                utf8(b"foo"),
                utf8(b"bar"),
                ctx
            );
            create_lemon(ctx);
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
            lemon::create_lemon(ctx);
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
            lemon::create_lemon(ctx);
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
            lemon::create_lemon(ctx);
            lemon::create_lemon(ctx);
        };
        test_scenario::next_tx(scenario, alice());
        {
            let lemons_amount = test_scenario::ids_for_sender<Lemon>(scenario);
            assert!(vector::length(&lemons_amount) == 2, 0);
        };
        test_scenario::end(scenario_val);
    }
}