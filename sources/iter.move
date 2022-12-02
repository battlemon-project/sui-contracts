module contracts::iter {
    use std::option::{Self, Option};
    use std::vector;

    struct Iter<T: copy> has store, drop {
        counter: u64,
        iterable: vector<T>,
    }

    public fun from<T: copy>(vec: vector<T>): Iter<T> {
        let iter = Iter {
            counter: 0,
            iterable: vec,
        };

        iter
    }

    public fun check<T: copy>(self: &Iter<T>): bool {
        if (self.counter == vector::length(&self.iterable)) {
            false
        }  else {
            true
        }
    }

    public fun next<T: copy>(self: &mut Iter<T>): Option<T> {
        if (self.counter == vector::length(&self.iterable)) {
            return option::none()
        };

        let ret = vector::borrow(&mut self.iterable, self.counter);
        self.counter = self.counter + 1;
        option::some(*ret)
    }
}
