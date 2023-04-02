module juice::ljc {
    use sui::tx_context::{TxContext};
    use sui::coin::{Self, Coin};
    use std::option;
    use sui::transfer;
    use sui::tx_context;
    use sui::object::{Self, UID};
    use sui::balance::{Self, Balance};
    use monolith::admin;
    use std::vector;
    use sui::url::{Self};
    use monolith::admin::AdminCap;

    struct LJC has drop {}

    struct JUICE has drop {}

    const JuiceDecimals: u8 = 9;
    const JuiceMaxSupply: u64 = 46000000 * 1000000000;
    const JuiceSymbol: vector<u8> = b"LJC";
    const JuiceName: vector<u8> = b"Lemon Juice";
    const JuiceDescription: vector<u8> = b"Lemon Juice is a special type of reward token that can be earned both in the Battlemon metaverse and in the shooter itself by completing specific tasks and objectives. These tokens can be used to unlock exclusive in-game items such as new weapons, abilities, and other gameplay elements. Unlike some other types of tokens, Lemon Juice tokens do not have a time limit for use, so players can save them up and use them whenever they want. This makes them a valuable and flexible resource for players who want to customize their gameplay experience and access new features.";
    const JuiceIconUrl: vector<u8> = b"https://demo.battlemon.com/favicon.png";
    const UnlockPeriod: u64 = 365;

    //--------------ERRORS
    const ECurrentEpochLessThanUnlockEpoch: u64 = 0;
    const ENoMoreEmissions: u64 = 0;

    struct JuiceTreasury has key {
        id: UID,
        locked: Balance<LJC>,
        unlocked: Balance<LJC>,
        emmisions: vector<u64>,
        next_epoch_unlock: u64,
    }

    fun init(witness: LJC, ctx: &mut TxContext) {
        let (treasury_cap, metadata) = coin::create_currency(
            witness,
            JuiceDecimals,
            JuiceSymbol,
            JuiceName,
            JuiceDescription,
            option::some(url::new_unsafe_from_bytes(JuiceIconUrl)),
            ctx
        );

        let admin_cap = admin::new(JUICE {}, ctx);
        transfer::transfer(admin_cap, tx_context::sender(ctx));

        let max_supply = coin::mint_balance(&mut treasury_cap, JuiceMaxSupply);

        let treasure = JuiceTreasury {
            id: object::new(ctx),
            locked: max_supply,
            unlocked: balance::zero(),
            emmisions: setup_emmisions(),
            next_epoch_unlock: tx_context::epoch(ctx),
        };

        transfer::public_freeze_object(metadata);
        transfer::share_object(treasure);
        transfer::public_transfer(treasury_cap, tx_context::sender(ctx))
    }

    public entry fun unlock(self: &mut JuiceTreasury, ctx: &mut TxContext) {
        assert!(!vector::is_empty(&self.emmisions), ENoMoreEmissions);
        let current_epoch = tx_context::epoch(ctx);
        assert!(self.next_epoch_unlock <= current_epoch, ECurrentEpochLessThanUnlockEpoch);

        let emission = vector::pop_back(&mut self.emmisions);
        let unlocked = balance::split(&mut self.locked, emission);
        balance::join(&mut self.unlocked, unlocked);

        self.next_epoch_unlock = self.next_epoch_unlock + UnlockPeriod;
    }

    public fun take(
        _: &AdminCap<LJC>,
        self: &mut JuiceTreasury,
        amount: u64,
        ctx: &mut TxContext
    ): Coin<LJC> {
        coin::take(&mut self.unlocked, amount, ctx)
    }

    public fun put(self: &mut JuiceTreasury, juice: Coin<LJC>) {
        coin::put(&mut self.unlocked, juice);
    }

    fun setup_emmisions(): vector<u64> {
        let ret = vector::empty();
        vector::push_back(&mut ret, 200000);
        vector::push_back(&mut ret, 400000);
        vector::push_back(&mut ret, 800000);
        vector::push_back(&mut ret, 1600000);

        ret
    }
}