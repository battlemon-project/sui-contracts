module contracts::pool {
    use sui::object::{UID};
    use sui::balance::Balance;
    use contracts::lemon::Lemon;

    struct Pool<phantom Witness, phantom Coin> has key {
        id: UID,
        coin: Balance<Coin>,
        lemons: vector<Lemon>,
    }


    // public fun create_pool<>
}
