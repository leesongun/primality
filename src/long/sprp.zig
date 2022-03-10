const high = @import("./util.zig").highbit;
const div = @import("./inline.zig").div;

fn mulmod(a: u64, b: u64, m: u64) u64 {
    return div(@as(u128, a) * b, m);
}

pub fn sprp(a: u64, p: u64) bool {
    const r = p - 1;
    var s = high(r);
    var b: u64 = a % p;
    if (b == 0) return true;
    while ((r & (s - 1) != 0) or ((r & s == 0 or b != 1) and (b + 1 != p))) {
        if (s == 2) return false;
        s >>= 1;
        b = mulmod(b, b, p);
        if (r & s != 0) b = mulmod(b, a, p);
    }
    return true;
}

//works only for odd numbers
pub fn sprp2(a: u64, p: u64) bool {
    const r = p - 1;
    var s = high(r);
    var b: u64 = a % p;
    if (b == 0) return true;
    while (r & (s - 1) != 0) {
        b = mulmod(b, b, p);
        s >>= 1;
        if (r & s != 0) b = mulmod(b, a, p);
    }
    if (b == 1) return true;
    while (b + 1 != p) {
        if (s == 2) return false;
        b = mulmod(b, b, p);
        s >>= 1;
    }
    return true;
}
