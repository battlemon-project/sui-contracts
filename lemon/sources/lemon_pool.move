module lemon::lemon_pool {
    use std::vector;
    use std::string::{Self, String};
    use sui::object::{Self, UID};
    use sui::coin::{Self, Coin};
    use sui::balance::{Self, Balance};
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};
    use juice::ljc::{Self, LJC, JuiceTreasury};
    use lemon::lemons::{Self, Blueprint, Lemons, Lemon};
    use monolith::admin::{AdminCap};
    use monolith::registry::Registry;
    use monolith::randomness::Randomness;
    use monolith::trait::Flavour;
    use monolith::random;
    use monolith::iter;

    // ====ERRORS====
    const ENotCorrectCoinAmount: u64 = 0;
    const ENotEnoughLemons: u64 = 1;
    const ENotEnoughPoolBalance: u64 = 2;

    // ====CONST====
    const LemonSwapReward: u64 = 950 * 1000000000;
    const JuiceRandomSwapCost: u64 = 1000 * 1000000000;
    const JuiceRandomSwapFee: u64 = 50 * 1000000000;
    const JuiceNoRandomSwapFee: u64 = 100 * 1000000000;
    const JuiceNotRandomSwapCost: u64 = 1050 * 1000000000;

    struct LemonPool has key {
        id: UID,
        balance: Balance<LJC>,
        blueprints: vector<Blueprint>,
    }

    fun init(ctx: &mut TxContext) {
        let pool = LemonPool {
            id: object::new(ctx),
            balance: balance::zero(),
            blueprints: vector::empty(),
        };
        transfer::share_object(pool);
    }

    public fun populate_pool(
        _: &AdminCap<Lemons>,
        self: &mut LemonPool,
        registry: &mut Registry<Lemons, String, Flavour<String>>,
        randomness: &mut Randomness<Lemons>,
        quantity: u64,
        ctx: &mut TxContext
    ) {
        let quantity_it = iter::from_range(0, quantity);
        while (iter::has_next(&quantity_it)) {
            let blueprint
                = lemons::new_blueprint(registry, randomness, string:: utf8(b"LJC"), ctx);
            vector::push_back(&mut self.blueprints, blueprint);
            iter::next(&mut quantity_it);
        };
    }


    public fun swap_juice_to_random(
        self: &mut LemonPool,
        treasury: &mut JuiceTreasury,
        juice: Coin<LJC>,
        ctx: &mut TxContext
    ) {
        let juice_value = coin::value(&juice);
        assert!((juice_value % JuiceRandomSwapCost) == 0, ENotCorrectCoinAmount);
        let swap_quantity = juice_value / JuiceRandomSwapCost;
        assert!(vector::length(&self.blueprints) >= swap_quantity, ENotEnoughLemons);

        let juice_to_treasury = coin::split(&mut juice, JuiceRandomSwapCost, ctx);
        ljc::put(treasury, juice_to_treasury);
        coin::put(&mut self.balance, juice);

        let swap_quantity_it = iter::from_range(0, swap_quantity);
        while (iter::has_next(&swap_quantity_it)) {
            let lemon = take_lemon(self, ctx);
            transfer::public_transfer(lemon, tx_context::sender(ctx));
            iter::next(&mut swap_quantity_it);
        };
    }

    public fun swap_juice(
        self: &mut LemonPool,
        treasury: &mut JuiceTreasury,
        juice: Coin<LJC>,
        index: u64,
        ctx: &mut TxContext
    ) {
        assert!(coin::value(&juice) == JuiceNotRandomSwapCost, ENotCorrectCoinAmount);
        let blueprint = vector::remove(&mut self.blueprints, index);

        let juice_to_treasury = coin::split(&mut juice, JuiceNotRandomSwapCost, ctx);
        ljc::put(treasury, juice_to_treasury);
        coin::put(&mut self.balance, juice);

        let lemon = lemons::from_blueprint(blueprint, ctx);
        transfer::public_transfer(lemon, tx_context::sender(ctx));
    }

    public fun swap_lemon(
        self: &mut LemonPool,
        lemons: vector<Lemon>,
        ctx: &mut TxContext
    ) {
        let lemons_quantity = vector::length(&lemons);
        let total_reward = (LemonSwapReward) * lemons_quantity;
        assert!(balance::value(&self.balance) < total_reward, ENotEnoughPoolBalance);

        let lemons_quantity_it = iter::from_range(0, lemons_quantity);
        while (iter::has_next(&lemons_quantity_it)) {
            let lemon = vector::pop_back(&mut lemons);
            let blueprint = lemons::into_blueprint(lemon);
            vector::push_back(&mut self.blueprints, blueprint);
            iter::next(&mut lemons_quantity_it);
        };
        vector::destroy_empty(lemons);
        let reward = coin::take(&mut self.balance, total_reward, ctx);
        transfer::public_transfer(reward, tx_context::sender(ctx));
    }

    // ====helpers====
    fun take_lemon(self: &mut LemonPool, ctx: &mut TxContext): Lemon {
        let idx = random::rng(0, vector::length(&self.blueprints), ctx);
        let blueprint = vector::remove(&mut self.blueprints, idx);
        lemons::from_blueprint(blueprint, ctx)
    }
}
