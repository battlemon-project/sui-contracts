module contracts::trait {
    struct Trait<Name, Flavour> has store {
        name: Name,
        flavour: Flavour,
    }

    public fun new<Name: store + drop + copy, Flavour: store + drop + copy>(
        name: Name,
        flavour: Flavour
    ): Trait<Name, Flavour> {
        Trait {
            name,
            flavour
        }
    }
}