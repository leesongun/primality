const std = @import("std");
const assert = std.debug.assert;
const expect = std.testing.expect;
const expectEq = std.testing.expectEqual;

pub fn jacobi(a: u64, b: u64) u1 {
    assert(a < b);
    assert(b & 1 == 1);
    assert(a != 0 or b == 1);

    if (a < 2) return 0;
    const c = if (a & 1 == 0) b - a else a;
    const d = if (a & 1 == 0) b - a + 1 else a;
    const e = @truncate(u1, d >> 1) * @truncate(u1, b >> 1);
    return jacobi(b % c, c) ^ e;
}

test "multiplicativity" {
    //need property testing library
}

test "known values" {
    var i: u64 = 3;
    while (i < 0x1000) {
        try expectEq(@truncate(u1, i >> 1), jacobi(i - 1, i));
        try expectEq(@truncate(u1, i >> 1) ^ @truncate(u1, i >> 2), jacobi(2, i));
        i += 2;
    }
}
