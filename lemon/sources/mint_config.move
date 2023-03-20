module lemon::mint_config {
    use std::vector;
    use sui::sui::SUI;
    use sui::object::{Self, UID};
    use sui::tx_context::{Self, TxContext};
    use sui::vec_map::{Self, VecMap};
    use sui::coin::{Self, Coin};
    use std::option;

    friend lemon::lemons;

    const ENotEnoughtFunds: u64 = 0;
    const EMintLimitForAccountIsReached: u64 = 1;
    const ESupplyLimitIsReached: u64 = 2;
    const EMintIsLocked: u64 = 3;


    const MintLimitPerAccount: u8 = 3;
    const Supply: u64 = 8888;

    struct MintConfig<phantom Kind> has key {
        id: UID,
        mint_cost: u64,
        minted: u64,
        minted_per_account: VecMap<address, u8>,
        supply: u64,
        whitelist: vector<address>,
        mint_unlocked: bool,
    }

    public(friend) fun new<Kind>(ctx: &mut TxContext): MintConfig<Kind> {
        MintConfig<Kind> {
            id: object::new(ctx),
            mint_cost: 0,
            minted: 0,
            minted_per_account: vec_map::empty(),
            supply: Supply,
            whitelist: vector::empty(),
            mint_unlocked: false,
        }
    }

    public fun check_supply<Kind>(self: &MintConfig<Kind>) {
        assert!(self.minted < self.supply, ESupplyLimitIsReached);
    }

    public fun check_sui_for_mint<Kind>(self: &MintConfig<Kind>, sui: &Coin<SUI>) {
        assert!(self.mint_cost == coin::value(sui), ENotEnoughtFunds);
    }

    public fun check_minted_for_account<Kind>(self: &MintConfig<Kind>, ctx: &mut TxContext) {
        let account = tx_context::sender(ctx);
        if (!vec_map::contains(&self.minted_per_account, &account)) return;

        let minted_for_account = vec_map::get(&self.minted_per_account, &account);
        assert!(*minted_for_account < MintLimitPerAccount, EMintLimitForAccountIsReached);
    }

    public fun check_mint_lock<Kind>(self: &MintConfig<Kind>) {
        assert!(self.mint_unlocked == true, EMintIsLocked);
    }

    public fun is_whitelisted<Kind>(self: &MintConfig<Kind>, ctx: &mut TxContext): bool {
        vector::contains(&self.whitelist, &tx_context::sender(ctx))
    }

    public(friend) fun increment_minted_for_account<Kind>(self: &mut MintConfig<Kind>, ctx: &mut TxContext) {
        let account = tx_context::sender(ctx);
        let account_idx_opt = vec_map::get_idx_opt(&self.minted_per_account, &account);

        if (option::is_none(&account_idx_opt)) {
            vec_map::insert(&mut self.minted_per_account, account, 1)
        } else {
            let account_idx = option::extract(&mut account_idx_opt);
            let (_, minted_for_account)
                = vec_map::get_entry_by_idx_mut(&mut self.minted_per_account, account_idx);
            let incremented = *minted_for_account + 1;
            *minted_for_account = incremented;
        };
    }

    public(friend) fun increment_minted<Kind>(self: &mut MintConfig<Kind>) {
        self.minted = self.minted + 1;
    }

    public(friend) fun add_to_whitelist<Kind>(self: &mut MintConfig<Kind>, account: address) {
        vector::push_back(&mut self.whitelist, account);
    }

    public(friend) fun unlock_mint<Kind>(self: &mut MintConfig<Kind>) {
        self.mint_unlocked = true;
    }

    public(friend) fun set_mint_cost<Kind>(self: &mut MintConfig<Kind>, cost: u64) {
        self.mint_cost = cost
    }
}
