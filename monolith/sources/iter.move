module monolith::iter {
    use std::option::{Self, Option};
    use std::vector;

    struct Iter<T: copy + drop> has store, drop {
        counter: u64,
        iterable: vector<T>,
    }

    public fun from<T: copy + drop>(vec: vector<T>): Iter<T> {
        Iter {
            counter: 0,
            iterable: vec,
        }
    }

    public fun from_range(begin: u64, end: u64): Iter<u64> {
        let ret = vector::empty<u64>();
        let current = begin;
        while (current < end) {
            vector::push_back(&mut ret, current);
            current = current + 1;
        };

        from(ret)
    }

    public fun has_next<T: copy + drop>(self: &Iter<T>): bool {
        if (self.counter == vector::length(&self.iterable)) {
            false
        }  else {
            true
        }
    }

    public fun next<T: copy + drop>(self: &mut Iter<T>): Option<T> {
        if (self.counter == vector::length(&self.iterable)) {
            return option::none()
        };

        let ret = vector::borrow(&mut self.iterable, self.counter);
        self.counter = self.counter + 1;
        option::some(*ret)
    }

    public fun next_unwrap<T: copy + drop>(self: &mut Iter<T>): T {
        let value = next(self);
        option::extract(&mut value)
    }
}
