module contracts::pool {
    use sui::object::{Self, UID};
    use sui::balance::{Self, Balance};
    use contracts::lemon::{Self, AdminCap, Lemons, Blueprint, Lemon};
    use sui::tx_context::TxContext;
    use sui::sui::SUI;
    use sui::coin::{Self, Coin};
    use std::vector;
    use sui::transfer;
    use contracts::registry::Registry;
    use contracts::trait::Flavour;
    use std::string::String;
    use contracts::random;
    use sui::tx_context;

    // ====ERRORS====
    const ENotCorrectCoinAmount: u64 = 5000;
    const EEmptyPool: u64 = 5001;
    const ENotEnoughPoolBalance: u64 = 5002;

    // ====CONST====
    const PRICE: u64 = 1000;

    struct Pool<phantom Coin> has key {
        id: UID,
        balance: Balance<Coin>,
        blueprints: vector<Blueprint>,
    }


    fun init(ctx: &mut TxContext) {
        let pool = Pool<SUI> {
            id: object::new(ctx),
            balance: balance::zero(),
            blueprints: vector::empty(),
        };
        transfer::share_object(pool);
    }

    public entry fun populate_pool(
        _: &AdminCap,
        pool: &mut Pool<SUI>,
        registry: &mut Registry<Lemons, String, Flavour<String>>,
        quantity: u32,
        ctx: &mut TxContext
    ) {
        let i = 0;
        let blueprints = vector::empty();
        while (i < quantity) {
            let blueprint = lemon::new_blueprint(registry, ctx);
            vector::push_back(&mut blueprints, blueprint);
            i = i + 1;
        };
        pool.blueprints = blueprints;
    }

    public entry fun swap_coins(coin: Coin<SUI>, pool: &mut Pool<SUI>, ctx: &mut TxContext) {
        assert!(vector::length(&pool.blueprints) > 0, EEmptyPool);
        assert!(coin::value(&coin) != PRICE, ENotCorrectCoinAmount);
        let coin_balance = coin::into_balance(coin);
        balance::join(&mut pool.balance, coin_balance);
        let lemon = take_lemon(pool, ctx);

        transfer::transfer(lemon, tx_context::sender(ctx))
    }

    public entry fun swap_lemon(lemon: Lemon, pool: &mut Pool<SUI>, ctx: &mut TxContext) {
        assert!(balance::value(&pool.balance) < PRICE, ENotEnoughPoolBalance);
        let blueprint = lemon::into_blueprint(lemon);
        vector::push_back(&mut pool.blueprints, blueprint);
        let reward_balance = balance::split(&mut pool.balance, PRICE);
        let reward = coin::from_balance(reward_balance, ctx);

        transfer::transfer(reward, tx_context::sender(ctx))
    }

    // ====helpers====
    fun take_lemon(pool: &mut Pool<SUI>, ctx: &mut TxContext): Lemon {
        let idx = random::rng(0, vector::length(&pool.blueprints), ctx);
        let blueprint = vector::remove(&mut pool.blueprints, idx);
        lemon::from_blueprint(blueprint, ctx)
    }
}
