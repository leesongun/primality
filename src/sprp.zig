// p >= 2 i guess?
pub fn sprp(a: u64, p: u32) bool {
    const r = p - 1;
    var s = @as(u32, 1) << @truncate(u5, (31 - @clz(u32, r)));
    var b: u64 = a % p;
    var c: u64 = a % p;

    if (b == 0) return true;

    while (true) {
        if ((r & (s - 1) == 0) and ((r & s != 0 and b == 1) or (b + 1 == p))) {
            return true;
        }
        if (s == 2) return false;

        b = (b * b) % p;
        s >>= 1;

        if (r & s != 0) {
            b = (b * c) % p;
        }
    }
}

pub fn isprime(p: u32) bool {
    const arr = [_]u64{ 4230279247111683200, 14694767155120705706, 16641139526367750375 };
    if (p < 2) return false;
    return sprp(arr[0], p) and sprp(arr[1], p) and sprp(arr[2], p);
}

const print = @import("std").debug.print;
pub fn main() void {
    var i: u32 = 0;
    while (i < 100) {
        if (isprime(i)) {
            print("{d}\n", .{i});
        }
        i += 1;
    }
}
