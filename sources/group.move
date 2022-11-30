module contracts::group {
    struct Group<Name, Entry> has store {
        name: Name,
        entries: vector<Entry>
    }

    public fun new<Name, Entry>(
        name: Name,
        entries: vector<Entry>
    ): Group<Name, Entry> {
        Group<Name, Entry> {
            name,
            entries,
        }
    }

    public fun name<Name, Entry>(
        self: &Group<Name, Entry>
    ): &Name {
        &self.name
    }

    public fun entries<Name, Entry>(
        self: &Group<Name, Entry>
    ): &vector<Entry> {
        &self.entries
    }
}