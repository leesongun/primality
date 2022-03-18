const std = @import("std");
const assert = std.debug.assert;
const expect = std.testing.expect;
const expectEq = std.testing.expectEqual;

//worst case exponential
//jacobi(2,p)
pub fn jacobi2(a: u64, b: u64) u1 {
    assert(a < b);
    assert(b & 1 == 1);
    assert(a != 0 or b == 1);

    if (a < 2) return 0;
    const c = if (a & 1 == 0) b - a else a;
    const d = if (a & 1 == 0) b - a + 1 else a;
    const e = @truncate(u1, d >> 1) * @truncate(u1, b >> 1);
    return jacobi(b % c, c) ^ e;
}

pub fn jacobi(a: u64, b: u64) u1 {
    assert(a < b);
    assert(b & 1 == 1);
    assert(a != 0 or b == 1);

    if (a < 2) return 0;
    const c = a >> @intCast(u6,@ctz(u64, a));
    const e = @truncate(u1, @ctz(u64, a)) * @truncate(u1, @popCount(u64, b & 6));
    const f = @truncate(u1, c >> 1) * @truncate(u1, b >> 1);
    return jacobi(b % c, c) ^ e ^ f;
}

test "multiplicativity" {
    //need property testing library
}

test "known values" {
    var i: u64 = 3;
    while (i < 0x1000) {
        try expectEq(@truncate(u1, i >> 1), jacobi(i - 1, i));
        try expectEq(@truncate(u1, @popCount(u64, i & 6)), jacobi(2, i));
        i += 2;
    }
}
