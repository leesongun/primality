const std = @import("std");
const assert = std.debug.assert;
const expect = std.testing.expect;
const expectEq = std.testing.expectEqual;

const jacobi = @import("./jacobi.zig").jacobi;
const candidates = @import("./constant.zig").candidates;

const half = @import("./utils.zig").half;
const issquare = @import("./utils.zig").isoddsquare;
pub fn isprime(p: u32) bool {
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
    var s = @as(u32, 1) << @truncate(u5, (31 - @clz(u32, r)));

    var U: u64 = 1;
    var V: u64 = 1;
    var Q: u64 = q;

    const D: u64 = if (d & 2 == 0) d else p - d;

    var t: bool = undefined;
    while (s != 1) {
        if (r & (s - 1) == 0) {
            if (r & s != 0) {
                t = (U == 0);
            }
            t = t or (V == 0);
        }

        U = (U * V) % p;
        V = (V * V + 2 * (p - Q)) % p;
        Q = (Q * Q) % p;

        s >>= 1;

        if (r & s != 0) {
            // we can reduce number of branches
            // is it worth it?
            // retry after bench add
            // const tV = if ((U + V) & 1 == 0) V else V + p;
            // V = ((D * U + tV) / 2) % p;
            // U = ((U + tV) / 2) % p;
            {
                const tU = half(U + V, p) % p;
                const tV = half(D * U + V, p) % p;
                U = tU;
                V = tV;
            }
            Q = (Q * q) % p;
        }
    }
    return t and ((2 * q) % p == V);
}
