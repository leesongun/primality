const std = @import("std");
const assert = std.debug.assert;
const expect = std.testing.expect;

fn jacobi(a: u64, b: u64) u1 {
    assert(b & 1 == 1);
    assert(a <= b);
    assert(a != 0 or b == 1);

    if (a < 2) return 0;
    const c = if (a & 1 == 0) b - a else a;
    const d = if (a & 1 == 0) b - a + 1 else a;
    const e = @truncate(u1, d >> 1) * @truncate(u1, b >> 1);
    return jacobi(b % c, c) ^ e;
}

fn isoddsquare(a: u32) bool {
    if (a & 7 != 1) return false;
    const s = @floatToInt(u32, @sqrt(@intToFloat(f32, a)));
    return a == s * s;
}

fn isoddsquare_long(a: u64) bool {
    if (a & 7 != 1) return false;
    const s = @floatToInt(u64, @sqrt(@intToFloat(f64, a)));
    return a == s * s;
}

fn half(a: u64, b: u64) u64 {
    return if (a & 1 == 0) a >> 1 else (a + b) >> 1;
}

pub fn lucas(p: u32) bool {
    if (p & 1 == 0) return p == 2;
    if (p % 3 == 0) return p == 3;
    if (p % 5 == 0) return p == 5;
    if (isoddsquare(p)) return false;

    //https://lemire.me/blog/2018/02/21/iterating-over-set-bits-quickly/
    //should try inlined version
    const d = init: {
        var c: u64 = 0x502D_A253_4C96_99FD;
        while (c != 0) {
            const t = 2 * @as(u64, @ctz(u64, c)) + 7;
            const u = p % t;
            if (u == 0) return p == t;
            if (jacobi(u, t) == 1) break :init t;
            c ^= (c & -%c);
        }
        unreachable;
    };
    const q = if (d & 2 == 0) d >> 2 else p - (d + 1) / 4;
    var r = p + 1;

    var U: u64 = 0;
    var V: u64 = 2;
    var Q: u64 = 1;

    const D: u64 = if (d & 2 == 0) d else p - d;
    const P: u64 = p;
    while (r != 0) {
        U = (U * V) % p;
        V = (V * V + 2 * (p - Q)) % p;
        Q = (Q * Q) % p;
        if (r >> 31 == 1) {
            U = half(U + V, p) % p;
            V = half(D * U + V, p) % p;
            Q = (Q * q) % p;
        }

        r <<= 1;
    }
    return (2 * q - V) % p == 0;
}
