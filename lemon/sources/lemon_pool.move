module lemon::lemon_pool {
    use std::vector;
    use std::string::{Self, String};
    use sui::object::{Self, UID};
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
    const LEMON_SWAP_REWARD: u64 = 950 * 1000000000;
    const JUICE_SWAP_COST: u64 = 1000 * 1000000000;

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


    public entry fun swap_juice(
        juice: Coin<LJC>,
        pool: &mut LemonPool,
        ctx: &mut TxContext
    ) {
        let juice_value = coin::value(&juice);
        assert!((juice_value % JUICE_SWAP_COST) == 0, ENotCorrectCoinAmount);
        let swap_quantity = juice_value / JUICE_SWAP_COST;
        assert!(vector::length(&pool.blueprints) >= swap_quantity, ENotEnoughLemons);
        coin::put(&mut pool.balance, juice);

        let swap_quantity_it = iter::from_range(0, swap_quantity);
        while (iter::has_next(&swap_quantity_it)) {
            let lemon = take_lemon(pool, ctx);
            transfer::transfer(lemon, tx_context::sender(ctx));
            iter::next(&mut swap_quantity_it);
        };
    }

    public entry fun swap_lemons(
        lemons: vector<Lemon>,
        pool: &mut LemonPool,
        ctx: &mut TxContext
    ) {
        let lemons_quantity = vector::length(&lemons);
        let total_reward = (LEMON_SWAP_REWARD) * lemons_quantity;
        assert!(balance::value(&pool.balance) < total_reward, ENotEnoughPoolBalance);

        let lemons_quantity_it = iter::from_range(0, lemons_quantity);
        while (iter::has_next(&lemons_quantity_it)) {
            let lemon = vector::pop_back(&mut lemons);
            let blueprint = lemons::into_blueprint(lemon);
            vector::push_back(&mut pool.blueprints, blueprint);
            iter::next(&mut lemons_quantity_it);
        };

        let reward = coin::take(&mut pool.balance, total_reward, ctx);
        transfer::transfer(reward, tx_context::sender(ctx));
    }

    // ====helpers====
    fun take_lemon(pool: &mut LemonPool, ctx: &mut TxContext): Lemon {
        let idx = random::rng(0, vector::length(&pool.blueprints), ctx);
        let blueprint = vector::remove(&mut pool.blueprints, idx);
        lemons::from_blueprint(blueprint, ctx)
    }
}
