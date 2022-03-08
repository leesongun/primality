const std = @import("std");
const assert = std.debug.assert;
const expect = std.testing.expect;
const expectEq = std.testing.expectEqual;

pub fn isoddsquare(a: u32) bool {
    if (a & 7 != 1) return false;
    const s = @floatToInt(u32, @sqrt(@intToFloat(f32, a)));
    return a == s * s;
}

fn isoddsquare_long(a: u64) bool {
    if (a & 7 != 1) return false;
    const s = @floatToInt(u64, @sqrt(@intToFloat(f64, a)));
    return a == s * s;
}

pub fn half(a: u64, b: u64) u64 {
    assert(b & 1 == 1);
    assert(a <= ~b);
    return if (a & 1 == 0) (a >> 1) else ((a + b) >> 1);
}
