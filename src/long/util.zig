const std = @import("std");
const assert = std.debug.assert;
const expect = std.testing.expect;
const expectEq = std.testing.expectEqual;

pub fn isoddsquare(a: u64) bool {
    if (a & 7 != 1) return false;
    const s = @floatToInt(u64, @sqrt(@intToFloat(f64, a)));
    return a == s *% s;
}

//operation precedence to prevent overflows
//does zig guarantte left-to-right addition?
pub fn half(a: u64, b: u64) u64 {
    assert(b & 1 == 1);
    const c = @truncate(u1, a);
    return b - (b >> c) + (a >> 1);
}

pub fn highbit(a: u64) u64 {
    return @as(u64, 1) << ~@intCast(u6, @clz(u64, a));
}

test "isoddsquare" {
    var i: u64 = 1;
    while (i < (1 << 32)) {
        try expect(isoddsquare(i * i));
        i += 2;
    }

    i = 0;
    while (i < (1 << 32)) {
        try expect(!isoddsquare(i * i));
        i += 2;
    }
}
