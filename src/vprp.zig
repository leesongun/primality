const std = @import("std");
const assert = std.debug.assert;

const half = @import("./util.zig").half;
const high = @import("./util.zig").highbit;
const div = @import("./inline.zig").div;

//halfdiv
fn hd(a: u128, b: u64) u64 {
    return half(div(a, b), b);
}

pub fn vprp(p: u64, d: u64) bool {
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
            if (s == 2) {
                //q * jacobi(q,p) == P;
            }
        }

        U = div(@as(u128, U) * V, p);
        V = div(@as(u128, V) * V + @as(u128, 2) * (p - Q), p);
        Q = div(@as(u128, Q) * Q, p);

        s >>= 1;

        if (r & s != 0) {
            const tU = @as(u128, U);
            const tV = V;
            U = hd(tU + tV, p);
            V = hd(D * tU + tV, p);
            Q = div(@as(u128, Q) * q, p);
        }
    }
    return t and ((2 * q) % p == V) and ((q * q) % p == Q);
}

//how about using x^2+x+(p+5)/4 when 4k+3?
//also try using x^+x+(p-1)/2 for D=3
//q=p>>1 (actually correspond to 3, making jacobi calculation a bit )
//x^2+x+(p+3)/2 for D=5
//q=(p>>1)+2 (actually correspond to -5, making jacobi calculation )
//dont try x^2+x+(1/2) because it is equivalent or weaker than sprp(2)
pub fn vprp2(p: u64, d: u64) bool {
    const q = if (d & 2 == 0) p - (d >> 2) else (d + 1) / 4;
    const r = p + 1;
    var s = high(r);

    const D: u64 = if (d & 2 == 0) d else p - d;

    var U: u64 = 1;
    var V: u64 = 1;
    var Q: u64 = q;

    while (r & (s - 1) != 0) {
        U = div(@as(u128, U) * V, p);
        V = div(@as(u128, V) * V + @as(u128, 2) * (p - Q), p);
        Q = div(@as(u128, Q) * Q, p);

        s >>= 1;

        if (r & s != 0) {
            const tU = @as(u128, U);
            const tV = V;
            U = hd(tU + tV, p);
            V = hd(D * tU + tV, p);
            Q = div(@as(u128, Q) * q, p);
        }
    }
    outer: {
        if (U == 0) break :outer;
        while (s != 2) {
            if (V == 0) break :outer;
            V = div(@as(u128, V) * V + @as(u128, 2) * (p - Q), p);
            Q = div(@as(u128, Q) * Q, p);
            s >>= 1;
        }
        return (V == 0 and (Q + q == p));
    }
    while (s != 2) {
        Q = div(@as(u128, Q) * Q, p);
        s >>= 1;
    }
    return Q == q;
}

//for 4k+1 numbers
pub fn vprp3(p: u64, d: u64) bool {
    const q = if (d & 2 == 0) p - (d >> 2) else (d + 1) / 4;
    const r = p - 1;
    var s = high(r);

    const D: u64 = if (d & 2 == 0) d else p - d;

    var U: u64 = 1;
    var V: u64 = 1;
    var Q: u64 = q;

    while (r & (s - 1) != 0) {
        U = div(@as(u128, U) * V, p);
        V = div(@as(u128, V) * V + @as(u128, 2) * (p - Q), p);
        Q = div(@as(u128, Q) * Q, p);

        s >>= 1;

        if (r & s != 0) {
            const tU = @as(u128, U);
            const tV = V;
            U = hd(tU + tV, p);
            V = hd(D * tU + tV, p);
            Q = div(@as(u128, Q) * q, p);
        }
    }
    var t = (Q == 1);
    while (s != 2) {
        if (Q == p - 1) t = true;
        //t = t or (Q==1);
        U = div(@as(u128, U) * V, p);
        V = div(@as(u128, V) * V + @as(u128, 2) * (p - Q), p);
        Q = div(@as(u128, Q) * Q, p);
        s >>= 1;
    }
    if (t) return (U == p - V);
    if (Q == p - 1)
        return div(D * @as(u128, U), p) == p - V;
    return false;
}

pub fn vprp4(p: u64, d: u64) bool {
    const q = if (d & 2 == 0) p - (d >> 2) else (d + 1) / 4;
    const r = p - 1 + (p & 2);
    var s = high(r);
    const D: u64 = if (d & 2 == 0) d else p - d;
    var U: u64 = 1;
    var V: u64 = 1;
    var Q: u64 = q;
    while (r & (s - 1) != 0) {
        U = div(@as(u128, U) * V, p);
        V = div(@as(u128, V) * V + @as(u128, 2) * (p - Q), p);
        Q = div(@as(u128, Q) * Q, p);
        s >>= 1;
        if (r & s != 0) {
            const tU = @as(u128, U);
            const tV = V;
            U = hd(tU + tV, p);
            V = hd(D * tU + tV, p);
            Q = div(@as(u128, Q) * q, p);
        }
    }
    if (p & 2 == 0) {
        var t = (Q == 1);
        while (s != 2) {
            if (Q == p - 1) t = true;
            //t = t or (Q==1);
            U = div(@as(u128, U) * V, p);
            V = div(@as(u128, V) * V + @as(u128, 2) * (p - Q), p);
            Q = div(@as(u128, Q) * Q, p);
            s >>= 1;
        }
        if (t) return (U == p - V);
        if (Q == p - 1) return div(D * @as(u128, U), p) == p - V;
        return false;
    } else outer: {
        if (U == 0) break :outer;
        while (s != 2) {
            if (V == 0) break :outer;
            V = div(@as(u128, V) * V + @as(u128, 2) * (p - Q), p);
            Q = div(@as(u128, Q) * Q, p);
            s >>= 1;
        }
        return (V == 0 and (Q + q == p));
    }
    while (s != 2) {
        Q = div(@as(u128, Q) * Q, p);
        s >>= 1;
    }
    return Q == q;
}
