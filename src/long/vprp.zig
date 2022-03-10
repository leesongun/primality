const std = @import("std");
const assert = std.debug.assert;
const expect = std.testing.expect;
const expectEq = std.testing.expectEqual;

const half = @import("./util.zig").half;
const high = @import("./util.zig").highbit;
const div = @import("./inline.zig").div;

//halfdiv
fn hd(a: u128, b: u64) u64 {
    return half(div(a, b), b);
}

pub fn vprp(p: u64, d:u64) bool {
    const q = if (d & 2 == 0) p - (d >> 2) else (d + 1) / 4;
    const r = p + 1;
    var s = high(r);
    var t: bool = undefined;

    const D: u64 = if (d & 2 == 0) d else p - d;

    var U: u64 = 1;
    var V: u64 = 1;
    var Q: u64 = q;

    while (s != 1) {
        if (r & (s - 1) == 0) {
            if (r & s != 0) {
                t = (U == 0);
            }
            t = t or (V == 0);
        }

        U = div(@as(u128, U) * V, p);
        V = div(@as(u128, V) * V + @as(u128, 2) * (p - Q), p);
        Q = div(@as(u128, Q) * Q, p);

        s >>= 1;

        if (r & s != 0) {
            const tU = @as(u128, U);
            const tV = @as(u128, V);
            U = hd(tU + tV, p);
            V = hd(D * tU + tV, p);
            Q = div(@as(u128, Q) * q, p);
        }
    }
    return t and ((2 * q) % p == V) and ((q * q) % p == Q);
}

//also try vprp2 in the same spirit of sprp2