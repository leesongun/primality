pub const candidates = init: {
    var c: u64 = 0;
    const list = [_]u32{ 7, 11, 13, 15, 17, 19, 21, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97, 101, 103, 107, 109, 113, 127, 131 };
    for (list) |v| {
        c |= @as(u64, 1) << ((v - 7) / 2);
    }
    break :init c;
};

//for debugging
const print = @import("std").debug.print;
pub fn main() void {
    print("0x{X}\n", .{candidates});

    var c = candidates;
    while (c != 0) {
        const t = 2 * @as(u64, @ctz(u64, c)) + 7;
        print("{d}\n", .{t});
        c ^= (c & -%c);
    }
}
