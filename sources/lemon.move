module contracts::lemon {
    use std::string::String;
    use sui::object::{Self, UID};
    use sui::url::{Self, Url};
    use sui::tx_context::{Self as tx_ctx, TxContext};
    use sui::transfer;
    use sui::dynamic_field;
    use contracts::trait::{Self, Trait};
    use contracts::equipment::{Self, Equipment};
    use contracts::item::{Self, Item};


    // ------------------------ERRORS----------------------
    const EItemProhibbitedForAdding: u64 = 256;

    // ------------------------Structs---------------------

    struct Flavour has store, drop, copy {
        name: String,
        weight: u8,
    }

    struct Lemon has key {
        id: UID,
        url: Url,
        traits: vector<Trait<String, String>>
    }

    struct AdminCap has key {
        id: UID,
    }

    // ================Public EntryPoints=====================

    fun populate_lemon_trait_registry(registry: &mut Registry<Lemon, String, Flavour>) {
        // exo
        let exo_flavours = &mut vector::empty<Flavour>();
        vector::push_back(
            exo_flavours,
            new_flavour(b"Exo_Steel_Exoskeleton_AA01", 127)
        );
        vector::push_back(
            exo_flavours,
            new_flavour(b"Exo_Snowwhite_Exoskeleton_AA02", 255)
        );
        let group_name = string::utf8(b"exo");
        registry::add<Lemon, String, Flavour>(registry, group_name, *exo_flavours);
        // eyes
        let eyes_flavours = &mut vector::empty<Flavour>();
        vector::push_back(
            eyes_flavours,
            new_flavour(b"Eyes_Blue_AA01", 127)
        );
        vector::push_back(
            eyes_flavours,
            new_flavour(b"Eyes_Green_AA02", 255)
        );
        let group_name = string::utf8(b"eyes");
        registry::add<Lemon, String, Flavour>(registry, group_name, *eyes_flavours);
        // head
        let head_flavours = &mut vector::empty<Flavour>();
        vector::push_back(
            head_flavours,
            new_flavour(b"Head_Fresh_Lemon_AA01", 127)
        );
        vector::push_back(
            head_flavours,
            new_flavour(b"Head_Zombie_ZA01", 255)
        );
        let group_name = string::utf8(b"head");
        registry::add<Lemon, String, Flavour>(registry, group_name, *head_flavours);
        // face
        let face_flavours = &mut vector::empty<Flavour>();
        vector::push_back(
            face_flavours,
            new_flavour(b"Face_Ninja_Balaclava_NA_01", 63)
        );
        vector::push_back(
            face_flavours,
            new_flavour(b"Face_Gas_Mask_MA01", 126)
        );
        vector::push_back(
            face_flavours,
            new_flavour(b"Face_Cowboy_Scarf_CA01", 189)
        );
        vector::push_back(
            face_flavours,
            new_flavour(b"Face_Sunglasses_RA01", 255)
        );
        let group_name = string::utf8(b"face");
        registry::add<Lemon, String, Flavour>(registry, group_name, *face_flavours);
        //teeth
        let teeth_flavours = &mut vector::empty<Flavour>();
        vector::push_back(
            teeth_flavours,
            new_flavour(b"Teeth_Grga_AA02", 63)
        );
        vector::push_back(
            teeth_flavours,
            new_flavour(b"Teeth_Hollywood_AA01", 126)
        );
        vector::push_back(
            teeth_flavours,
            new_flavour(b"Teeth_Oldstyle_AA04", 189)
        );
        vector::push_back(
            teeth_flavours,
            new_flavour(b"Teeth_Sharp_AA03", 255)
        );
        let group_name = string::utf8(b"teeth");
        registry::add<Lemon, String, Flavour>(registry, group_name, *teeth_flavours);
    }

    /// Temploray solution for the ability to test init function while this problem
    /// https://github.com/MystenLabs/sui/issues/6185 is not solved
    fun init_helper(ctx: &mut TxContext) {
        let admin = AdminCap {
            id: object::new(ctx),
        };
        let id = object::new(ctx);
        let seed = hash::sha3_256(object::uid_to_bytes(&id));
        let trait_registry = registry::new<Lemon, String, Flavour>(id, option::some(seed));
        populate_lemon_trait_registry(&mut trait_registry);
        let item_registry = equipment::new(ctx);

        transfer::transfer(admin, tx_context::sender(ctx));
        transfer::share_object(trait_registry);
        transfer::share_object(item_registry);
    }

    // todo: add one-time witness initialization
    fun init(ctx: &mut TxContext) {
        init_helper(ctx)
    }


    fun new_lemon(
        registry: &mut Registry<Lemon, String, Flavour>,
        ctx: &mut TxContext
    ): Lemon {
        Lemon {
            id: object::new(ctx),
            url: url::new_unsafe_from_bytes(b"foo.bar"),
            traits: generate_traits(registry, ctx),
        }
    }

    fun generate_traits(
        registry: &mut Registry<Lemon, String, Flavour>,
        ctx: &mut TxContext
    ): vector<Trait<String, String>> {
        registry::update_seed(registry, ctx);
        let traits = vector::empty();
        let traits_groups = registry::borrow_traits_groups(registry);
        let seed = registry::borrow_seed(registry);

        let i = 0;
        while (i < vector::length(traits_groups)) {
            let trait_group = vector::borrow(traits_groups, i);
            let chance = vector::borrow(seed, i);
            let j = 0;
            // let
            // while (j < vector::length(trait_group))
        };

        traits
    }

    // ================Public EntryPoints=====================
    public entry fun create_lemon(registry: &mut Registry<Lemon, String, Flavour>, ctx: &mut TxContext) {
        let lemon = new_lemon(registry, ctx);
        transfer::transfer(lemon, tx_ctx::sender(ctx))
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
        registry: &mut Registry<Lemon, String, Flavour>
    ) {}

    // ================Helpers=====================
    fun new_flavour(name: vector<u8>, weight: u8): Flavour {
        Flavour {
            name: string::utf8(name),
            weight
        }
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
    use contracts::registry::Registry;
    use contracts::registry;
    use std::option;
    use std::string;
    use std::vector;
    use std::hash;

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
            lemon::create_lemon(ctx);
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