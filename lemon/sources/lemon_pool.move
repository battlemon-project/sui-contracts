module lemon::lemon_pool {
    use std::vector;
    use std::string::{Self, String};
    use sui::object::{Self, UID, ID};
    use sui::coin::{Self, Coin};
    use sui::balance::{Self, Balance};
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};
    use juice::ljc::LJC;
    use lemon::lemons::{Self, Blueprint, LEMONS, Lemon};
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

    public entry fun populate_pool(
        _: &AdminCap<LEMONS>,
        self: &mut LemonPool,
        registry: &mut Registry<LEMONS, String, Flavour<String>>,
        randomness: &mut Randomness<LEMONS>,
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


    public entry fun swap_juice_to_random(
        self: &mut LemonPool,
        juice: Coin<LJC>,
        ctx: &mut TxContext
    ) {
        let juice_value = coin::value(&juice);
        assert!((juice_value % JuiceRandomSwapCost) == 0, ENotCorrectCoinAmount);
        let swap_quantity = juice_value / JuiceRandomSwapCost;
        assert!(vector::length(&self.blueprints) >= swap_quantity, ENotEnoughLemons);
        coin::put(&mut self.balance, juice);

        let swap_quantity_it = iter::from_range(0, swap_quantity);
        while (iter::has_next(&swap_quantity_it)) {
            let lemon = take_lemon(self, ctx);
            transfer::transfer(lemon, tx_context::sender(ctx));
            iter::next(&mut swap_quantity_it);
        };
    }

    public entry fun swap_juice(
        self: &mut LemonPool,
        juice: Coin<LJC>,
        index: u64,
        ctx: &mut TxContext
    ) {
        assert!(coin::value(&juice) == JuiceNotRandomSwapCost, ENotCorrectCoinAmount);
        let blueprint = vector::remove(&mut self.blueprints, index);
        coin::put(&mut self.balance, juice);
        let lemon = lemons::from_blueprint(blueprint, ctx);
        transfer::transfer(lemon, tx_context::sender(ctx));
    }

    public entry fun swap_lemons(
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

        let reward = coin::take(&mut self.balance, total_reward, ctx);
        transfer::transfer(reward, tx_context::sender(ctx));
    }

    // ====helpers====
    fun take_lemon(self: &mut LemonPool, ctx: &mut TxContext): Lemon {
        let idx = random::rng(0, vector::length(&self.blueprints), ctx);
        let blueprint = vector::remove(&mut self.blueprints, idx);
        lemons::from_blueprint(blueprint, ctx)
    }
}
