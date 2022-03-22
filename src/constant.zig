const std = @import("std");
const assert = std.debug.assert;
const expectEq = std.testing.expectEqual;

//heuristically, this shouldn't be enough for 64bit

const list = [_]u8{ 7, 11, 13, 15, 17, 19, 21, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97, 101, 103, 107, 109, 113, 127, 131 };

pub const candidates = init: {
    var c: u64 = 0;
    for (list) |v| c |= @as(u64, 1) << ((v - 7) / 2);
    break :init c;
};

test {
    var c = candidates;
    for (list) |v| {
        try expectEq(v, 2 * @as(u8, @ctz(u64, c)) + 7);
        c &= c - 1;
    }
    try expectEq(c, 0);
}
