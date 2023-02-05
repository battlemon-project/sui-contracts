module contracts::item {
    use sui::object::{Self, UID, ID};
    use sui::url::{Self, Url};
    use std::string::{Self, String};
    use sui::tx_context::{Self, TxContext};
    use sui::transfer;
    use contracts::registry::{Self, Registry};
    use std::vector;
    use contracts::trait::{Self, Flavour, Trait};
    use sui::event::emit;
    use contracts::random;
    use std::option;

    // ====Types====
    struct Items {}

    struct Item<TraitName, TraitFlavour> has key, store {
        id: UID,
        url: Url,
        traits: vector<Trait<TraitName, TraitFlavour>>
    }

    // ====Init====
    fun init(ctx: &mut TxContext) {
        let registry = registry::create<Items, String, Flavour<String>>(ctx);
        populate_registry(&mut registry);
        transfer::share_object(registry);
    }

    fun populate_registry(registry: &mut Registry<Items, String, Flavour<String>>) {
        // back
        let back_flavours = &mut vector::empty<Flavour<String>>();
        vector::push_back(
            back_flavours,
            new_flavour(b"Back_Insecticide_Bottle", 64)
        );
        vector::push_back(
            back_flavours,
            new_flavour(b"Back_Bomb_Barrel", 128)
        );
        vector::push_back(
            back_flavours,
            new_flavour(b"Back_Tactical_Backpack", 192)
        );
        vector::push_back(
            back_flavours,
            new_flavour(b"Back_Adventurer_Backpack", 255)
        );
        let group_name = string::utf8(b"back");
        registry::append<Items, String, Flavour<String>>(registry, &group_name, *back_flavours);

        // cap
        let cap_flavours = &mut vector::empty<Flavour<String>>();
        vector::push_back(
            cap_flavours,
            new_flavour(b"Cap_Baseball_Cap_Red", 17)
        );
        vector::push_back(
            cap_flavours,
            new_flavour(b"Cap_Ladle", 34)
        );
        vector::push_back(
            cap_flavours,
            new_flavour(b"Cap_Cheef_Hat", 51)
        );
        vector::push_back(
            cap_flavours,
            new_flavour(b"Cap_Cone_Armored_Hat", 68)
        );
        vector::push_back(
            cap_flavours,
            new_flavour(b"Cap_Cowboy_Hat", 85)
        );
        vector::push_back(
            cap_flavours,
            new_flavour(b"Cap_Sheriff_Hat", 102)
        );
        vector::push_back(
            cap_flavours,
            new_flavour(b"Cap_Military_Cap", 119)
        );
        vector::push_back(
            cap_flavours,
            new_flavour(b"Cap_Special_Forces_Beret", 136)
        );
        vector::push_back(
            cap_flavours,
            new_flavour(b"Cap_Tank_Helmet", 153)
        );
        vector::push_back(
            cap_flavours,
            new_flavour(b"Cap_Military_Helmet", 170)
        );
        vector::push_back(
            cap_flavours,
            new_flavour(b"Cap_Metallic_Cone_Hat", 187)
        );
        vector::push_back(
            cap_flavours,
            new_flavour(b"Cap_Assault_Helmet", 204)
        );
        vector::push_back(
            cap_flavours,
            new_flavour(b"Cap_Cane_Cone_Hat", 221)
        );
        vector::push_back(
            cap_flavours,
            new_flavour(b"Cap_Cocked_Hat", 238)
        );
        vector::push_back(
            cap_flavours,
            new_flavour(b"Cap_Pirate_Bandana", 255)
        );
        let group_name = string::utf8(b"cap");
        registry::append<Items, String, Flavour<String>>(registry, &group_name, *cap_flavours);

        // cloth
        let cloth_flavours = &mut vector::empty<Flavour<String>>();
        vector::push_back(
            cloth_flavours,
            new_flavour(b"Cloth_Chain_Gold_RA01", 36)
        );
        vector::push_back(
            cloth_flavours,
            new_flavour(b"Cloth_Cheef_Sash_KA01", 72)
        );
        vector::push_back(
            cloth_flavours,
            new_flavour(b"Cloth_Eastern_Armor_Belt_NA02", 108)
        );
        vector::push_back(
            cloth_flavours,
            new_flavour(b"Cloth_Ninja_Waistband_NA01", 144)
        );
        vector::push_back(
            cloth_flavours,
            new_flavour(b"Cloth_Poncho_CA01", 180)
        );
        vector::push_back(
            cloth_flavours,
            new_flavour(b"Cloth_Bandolier_MA02", 216)
        );
        vector::push_back(
            cloth_flavours,
            new_flavour(b"Cloth_Skull_Belt_PA01", 255)
        );
        let group_name = string::utf8(b"cloth");
        registry::append<Items, String, Flavour<String>>(registry, &group_name, *cloth_flavours);

        //belt
        let belt_flavours = &mut vector::empty<Flavour<String>>();
        vector::push_back(
            belt_flavours,
            new_flavour(b"Cloth_Chain_Gold_RA01", 42)
        );
        vector::push_back(
            belt_flavours,
            new_flavour(b"Cloth_Cheef_Sash_KA01", 84)
        );
        vector::push_back(
            belt_flavours,
            new_flavour(b"Cloth_Eastern_Armor_Belt_NA02", 126)
        );
        vector::push_back(
            belt_flavours,
            new_flavour(b"Cloth_Ninja_Waistband_NA01", 168)
        );
        vector::push_back(
            belt_flavours,
            new_flavour(b"Cloth_Poncho_CA01", 210)
        );
        vector::push_back(
            belt_flavours,
            new_flavour(b"Cloth_Bandolier_MA02", 255)
        );
        let group_name = string::utf8(b"belt");
        registry::append<Items, String, Flavour<String>>(registry, &group_name, *belt_flavours);

        // cold_arms
        let cold_arms_flavours = &mut vector::empty<Flavour<String>>();
        vector::push_back(
            cold_arms_flavours,
            new_flavour(b"ColdArms_Bottle_Rose_RA01", 63)
        );
        vector::push_back(
            cold_arms_flavours,
            new_flavour(b"ColdArms_Grappling_Hook_PA01", 126)
        );
        vector::push_back(
            cold_arms_flavours,
            new_flavour(b"ColdArms_Chopper_Knife_KA01", 189)
        );
        vector::push_back(
            cold_arms_flavours,
            new_flavour(b"ColdArms_Katana_NA01", 255)
        );
        let group_name = string::utf8(b"cold_arms");
        registry::append<Items, String, Flavour<String>>(registry, &group_name, *cold_arms_flavours);
        // face
        let face_flavours = &mut vector::empty<Flavour<String>>();
        vector::push_back(
            face_flavours,
            new_flavour(b"Face_Sunglasses_RA01", 85)
        );
        vector::push_back(
            face_flavours,
            new_flavour(b"Face_Visor_VR_VR01", 170)
        );
        vector::push_back(
            face_flavours,
            new_flavour(b"Face_Cowboy_Scarf_CA01", 255)
        );
        let group_name = string::utf8(b"face");
        registry::append<Items, String, Flavour<String>>(registry, &group_name, *face_flavours);
        // fire_arm
        let fire_arm_flavours = &mut vector::empty<Flavour<String>>();
        vector::push_back(
            fire_arm_flavours,
            new_flavour(b"FireArms_Revolver_CA01", 43)
        );
        vector::push_back(
            fire_arm_flavours,
            new_flavour(b"FireArms_Grenade_Launcher_AA03", 86)
        );
        vector::push_back(
            fire_arm_flavours,
            new_flavour(b"FireArms_Handgun_SMG_AA04", 129)
        );
        vector::push_back(
            fire_arm_flavours,
            new_flavour(b"FireArms_Assault_Rifle_AA01", 172)
        );
        vector::push_back(
            fire_arm_flavours,
            new_flavour(b"FireArms_Assault_Rifle_AA02", 215)
        );
        vector::push_back(
            fire_arm_flavours,
            new_flavour(b"FireArms_Sniper_Rifle_AA05", 255)
        );
        let group_name = string::utf8(b"fire_arm");
        registry::append<Items, String, Flavour<String>>(registry, &group_name, *fire_arm_flavours);
        // shoes
        let shoes_flavours = &mut vector::empty<Flavour<String>>();
        vector::push_back(
            shoes_flavours,
            new_flavour(b"Shoes_Kicks_SA01", 63)
        );
        vector::push_back(
            shoes_flavours,
            new_flavour(b"Shoes_Armored_Shoes_AA01", 126)
        );
        vector::push_back(
            shoes_flavours,
            new_flavour(b"Shoes_Military_Shoes_MA01", 189)
        );
        vector::push_back(
            shoes_flavours,
            new_flavour(b"Shoes_Kicks_SA02", 255)
        );
        let group_name = string::utf8(b"shoes");
        registry::append<Items, String, Flavour<String>>(registry, &group_name, *shoes_flavours);
    }

    // ====Entries====
    public entry fun create_item(registry: &mut Registry<Items, String, Flavour<String>>, ctx: &mut TxContext) {
        let item = new_item(registry, ctx);
        emit(ItemCreated {
            id: object::id(&item),
            url: item.url,
            traits: item.traits,
        });
        transfer::transfer(item, tx_context::sender(ctx));
    }

    // ====Helpers====
    public fun new_item(
        registry: &mut Registry<Items, String, Flavour<String>>,
        ctx: &mut TxContext
    ): Item<String, String> {
        let registry_size = registry::size(registry);
        let idx = random::rng(0, registry_size, ctx);
        let trait_opt = trait::generate_by_idx(registry, idx, ctx);
        let trait = option::extract(&mut trait_opt);
        let traits = vector::empty();
        vector::push_back(&mut traits, trait);
        Item {
            id: object::new(ctx),
            url: url::new_unsafe_from_bytes(b"foo"),
            traits,
        }
    }

    public fun uid<TraitName: copy, TraitFlavour: copy>(self: &Item<TraitName, TraitFlavour>): &UID {
        &self.id
    }

    public fun traits<TraitName: copy, TraitFlavour: copy>(
        self: &Item<TraitName, TraitFlavour>
    ): vector<Trait<TraitName, TraitFlavour>> {
        self.traits
    }
    // public fun kind(self: &Item): String {
    //     self.kind
    // }
    //
    // public fun flavour(self: &Item): String {
    //     self.flavour
    // }


    public fun new_flavour(name: vector<u8>, weight: u64): Flavour<String> {
        trait::new_flavour(string::utf8(name), option::some(weight))
    }

    // ====Events====
    struct ItemCreated has copy, drop {
        id: ID,
        url: Url,
        traits: vector<Trait<String, String>>,
    }
}
