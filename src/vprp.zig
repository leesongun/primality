const std = @import("std");
const assert = std.debug.assert;

const half = @import("./util.zig").half;
const high = @import("./util.zig").highbit;
const div = @import("./inline.zig").div;

fn halfdiv(a: u128, b: u64) u64 {
    return half(div(a, b), b);
}

inline fn double(U: *u64, V: *u64, Q: *u64, s: *u64, p: u64, comptime m: comptime_int) void {
    if (m == 2) U.* = div(@as(u128, U.*) * V.*, p);
    if (m != 0) V.* = div(@as(u128, V.*) * V.* + @as(u128, 2) * (p - Q.*), p);
    Q.* = div(@as(u128, Q.*) * Q.*, p);
    s.* >>= 1;
}

//how about multiplying Q by 4 instead of dividing U,V by 2?
pub fn vprp(p: u64, d: u64) bool {
    const q = if (d & 2 == 0) p - (d >> 2) else (d + 1) / 4;
    const r = p - 1 + (p & 2);
    var s = high(r);
    const D: u64 = if (d & 2 == 0) d else p - d;
    var U: u64 = 1;
    var V: u64 = 1;
    var Q: u64 = q;
    while (r & (s - 1) != 0) {
        double(&U, &V, &Q, &s, p, 2);
        if (r & s != 0) {
            const tU = @as(u128, U);
            const tV = V;
            U = halfdiv(tU + tV, p);
            V = halfdiv(D * tU + tV, p);
            Q = div(@as(u128, Q) * q, p);
        }
    }
    if (p & 2 == 0) {
        var t = (Q == 1);
        while (s != 2) {
            if (Q == p - 1) t = true;
            double(&U, &V, &Q, &s, p, 2);
        }
        if (t) return U == p - V;
        if (Q == p - 1) return div(D * @as(u128, U), p) == p - V;
        return false;
    } else if (U != 0) while (s != 2) {
        if (V == 0) break;
        double(&U, &V, &Q, &s, p, 1);
    } else return V == 0 and Q + q == p;
    while (s != 2) double(&U, &V, &Q, &s, p, 0);
    return Q == q;
}
