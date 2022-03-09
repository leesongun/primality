const std = @import("std");
const assert = std.debug.assert;
const expect = std.testing.expect;
const expectEq = std.testing.expectEqual;

pub fn isoddsquare(a: u32) bool {
    if (a & 7 != 1) return false;
    const s = @floatToInt(u32, @sqrt(@intToFloat(f32, a)));
    return a == s *% s;
}

fn isoddsquare_long(a: u64) bool {
    if (a & 7 != 1) return false;
    const s = @floatToInt(u64, @sqrt(@intToFloat(f64, a)));
    return a == s *% s;
}

//half does not branch
pub fn half(a: u64, b: u64) u64 {
    assert(b & 1 == 1);
    return if (a & 1 == 0) (a >> 1) else ((a + b) >> 1);
}

test "isoddsquare" {
    var i: u32 = 1;
    while (i < (1 << 16)) {
        try expect(isoddsquare(i * i));
        var j: u32 = 1;
        const m: u32 = if (i == (1 << 16) - 1) 2 * i else 4 * i + 3;
        while (j <= m) {
            try expect(!isoddsquare(i * i + j));
            j += 1;
        }
        i += 2;
    }
}

test "isoddsquare_long" {
    var i: u64 = 1;
    while (i < (1 << 32)) {
        try expect(isoddsquare_long(i * i));
        i += 2;
    }
}
