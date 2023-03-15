module reward_pool::reward_pool {
    use juice::ljc::{Self, JuiceTreasury, LJC};
    use sui::vec_map::{Self, VecMap};
    use sui::object::{Self, UID};
    use sui::tx_context::{Self, TxContext};
    use sui::transfer;
    use monolith::admin::AdminCap;
    use monolith::iter;
    use sui::balance::{Self, Balance};
    use sui::coin;
    use std::option;

    struct REWARDS has drop {}

    struct RewardPool has key {
        id: UID,
        expected_rewards: VecMap<address, u64>,
        reward_pool: Balance<LJC>,
    }

    fun init(ctx: &mut TxContext) {
        let pool = RewardPool {
            id: object::new(ctx),
            expected_rewards: vec_map::empty(),
            reward_pool: balance::zero(),
        };
        transfer::share_object(pool);
    }

    public entry fun append(
        witness: &AdminCap<LJC>,
        self: &mut RewardPool,
        treasury: &mut JuiceTreasury,
        players: vector<address>,
        rewards: vector<u64>,
        ctx: &mut TxContext,
    ) {
        let total_payouts = sum(rewards);
        let juice = ljc::take(witness, treasury, total_payouts, ctx);
        let juice_balance = coin::into_balance(juice);
        balance::join(&mut self.reward_pool, juice_balance);

        let players_iter = iter::from(players);
        let rewards_iter = iter::from(rewards);
        while (iter::has_next(&players_iter)) {
            let player_address = iter::next_unwrap(&mut players_iter);
            let player_reward = iter::next_unwrap(&mut rewards_iter);

            let player_idx_opt = vec_map::get_idx_opt(&self.expected_rewards, &player_address);
            if (option::is_some(&player_idx_opt)) {
                let player_idx = option::extract(&mut player_idx_opt);
                let (_, old_player_reward)
                    = vec_map::get_entry_by_idx_mut(&mut self.expected_rewards, player_idx);
                *old_player_reward = *old_player_reward + player_reward;
            } else {
                vec_map::insert(&mut self.expected_rewards, player_address, player_reward);
            }
        }
    }

    public entry fun claim(
        self: &mut RewardPool,
        ctx: &mut TxContext,
    ) {
        let player_address = tx_context::sender(ctx);
        let (_, reward_amount) = vec_map::remove(&mut self.expected_rewards, &player_address);
        let juice_reward = coin::take(&mut self.reward_pool, reward_amount, ctx);
        transfer::transfer(juice_reward, player_address);
    }

    public entry fun withdraw(_: AdminCap<LJC>, self: &mut RewardPool, amount: u64, ctx: &mut TxContext) {
        let juice = coin::take(&mut self.reward_pool, amount, ctx);
        transfer::transfer(juice, tx_context::sender(ctx));
    }

    fun get_amount_of_reward(self: &mut RewardPool, ctx: &mut TxContext): u64 {
        let address = tx_context::sender(ctx);
        *vec_map::get(&self.expected_rewards, &address)
    }

    fun sum(rewards: vector<u64>): u64 {
        let iter = iter::from(rewards);
        let ret = 0;
        while (iter::has_next(&iter)) {
            let reward = iter::next_unwrap(&mut iter);
            ret = ret + reward;
        };
        ret
    }
}
