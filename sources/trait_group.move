module contracts::trait_group {
    struct TraitsGroup<Name, Flavour> has store {
        name: Name,
        flavours: vector<Flavour>
    }

    public fun new<Name, Flavour>(name: Name, flavours: vector<Flavour>): TraitsGroup<Name, Flavour> {
        TraitsGroup<Name, Flavour> {
            name,
            flavours,
        }
    }
}