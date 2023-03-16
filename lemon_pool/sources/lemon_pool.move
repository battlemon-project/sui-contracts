module lemon_pool::lemon_pool {
    use std::vector;
    use std::string::String;
    use sui::object::{Self, UID};
    use sui::coin::{Self, Coin};
    use sui::balance::{Self, Balance};
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};
    use juice::ljc::LJC;
    use lemon::lemon::{Self, Blueprint, LEMONS, Lemon};
    use monolith::admin::{AdminCap};
    use monolith::registry::Registry;
    use monolith::randomness::Randomness;
    use monolith::trait::Flavour;
    use monolith::random;

    // ====ERRORS====
    const ENotCorrectCoinAmount: u64 = 0;
    const EEmptyPool: u64 = 1;
    const ENotEnoughPoolBalance: u64 = 2;

    // ====CONST====
    const PRICE: u64 = 1000;

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
        admin: &AdminCap<LEMONS>,
        pool: &mut LemonPool,
        registry: &mut Registry<LEMONS, String, Flavour<String>>,
        randomness: &mut Randomness<LEMONS>,
        quantity: u32,
        ctx: &mut TxContext
    ) {
        let i = 0;
        let blueprints = vector::empty();
        while (i < quantity) {
            let blueprint = lemon::new_blueprint(admin, registry, randomness, ctx);
            vector::push_back(&mut blueprints, blueprint);
            i = i + 1;
        };
        pool.blueprints = blueprints;
    }


    public entry fun swap_coins(
        coin: Coin<LJC>,
        pool: &mut LemonPool,
        ctx: &mut TxContext
    ) {
        assert!(vector::length(&pool.blueprints) > 0, EEmptyPool);
        assert!(coin::value(&coin) != PRICE, ENotCorrectCoinAmount);
        let coin_balance = coin::into_balance(coin);
        balance::join(&mut pool.balance, coin_balance);
        let lemon = take_lemon(pool, ctx);

        transfer::transfer(lemon, tx_context::sender(ctx))
    }

    public entry fun swap_lemon(
        lemon: Lemon,
        pool: &mut LemonPool,
        ctx: &mut TxContext
    ) {
        assert!(balance::value(&pool.balance) < PRICE, ENotEnoughPoolBalance);
        let blueprint = lemon::into_blueprint(lemon);
        vector::push_back(&mut pool.blueprints, blueprint);
        let reward_balance = balance::split(&mut pool.balance, PRICE);
        let reward = coin::from_balance(reward_balance, ctx);

        transfer::transfer(reward, tx_context::sender(ctx))
    }

    // ====helpers====
    fun take_lemon(pool: &mut LemonPool, ctx: &mut TxContext): Lemon {
        let idx = random::rng(0, vector::length(&pool.blueprints), ctx);
        let blueprint = vector::remove(&mut pool.blueprints, idx);
        lemon::from_blueprint(blueprint, ctx)
    }
}
