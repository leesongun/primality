const std = @import("std");
const assert = std.debug.assert;
const expect = std.testing.expect;
const expectEq = std.testing.expectEqual;

pub fn div(a: u128, b: u64) u64 {
    const lo = @truncate(u64, a);
    const hi = @intCast(u64, a >> 64);
    return asm ("divq %[mod]"
        : [ret] "={rdx}" (-> u64),
        : [_] "{rax}" (lo),
          [_] "{rdx}" (hi),
          [mod] "r" (b),
    );
}

fn div2(a: u128, b: u64) u64 {
    return @intCast(u64, a % b);
}

test "div test" {
    var b: u64 = 0x502D_A253_4C96_99FD;
    var a: u128 = 0x502D_A253_4C96_99FD_DF99_69C4_352A; //_D205;
    while (a < 0x502D_A253_4C96_99FD_DF99_69C4_FFFF) {
        try expectEq(div2(a, b), div(a, b));
        a += 1;
    }
}
