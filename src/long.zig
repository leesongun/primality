const std = @import("std");
const assert = std.debug.assert;
const expect = std.testing.expect;
const expectEq = std.testing.expectEqual;

const jacobi = @import("./jacobi.zig").jacobi;
const candidates = @import("./constant.zig").candidates;

const half = @import("./util.zig").half;
const issquare = @import("./util.zig").isoddsquare_long;
pub fn isprime(p: u64) bool {
    if (p & 1 == 0) return p == 2;
    if (p % 3 == 0) return p == 3; //thankfully, MAX_INTs get sieved here
    if (p % 5 == 0) return p == 5;
    if (issquare(p)) return false;

    //should try inlined version
    const d = init: {
        var c: u64 = candidates;
        while (c != 0) {
            const t = 2 * @as(u64, @ctz(u64, c)) + 7;
            const u = p % t;
            if (u == 0) return p == t;
            if (jacobi(u, t) == 1) break :init t;
            c &= c - 1;
        }
        unreachable;
    };

    const q = if (d & 2 == 0) p - (d >> 2) else (d + 1) / 4;
    const r = p + 1;
    var s = @as(u64, 1) << @truncate(u5, (63 - @clz(u64, r)));
    var t: bool = undefined;

    const D: u64 = if (d & 2 == 0) d else p - d;

    //need to make this u128
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

        U = (@as(u128, U) * V) % p;
        V = (@as(u128, V) * V + 2 * (p - Q)) % p;
        Q = (@as(u128, Q) * Q) % p;

        s >>= 1;

        if (r & s != 0) {
            const tU = half((@as(u128, U) + V) % p, p);
            const tV = half((@as(u128, D) * U + V) % p, p);
            U = tU;
            V = tV;
            Q = (@as(u128, Q) * q) % p;
        }
    }
    return t and ((2 * q) % p == V) and ((q * q) % p == Q);
}
