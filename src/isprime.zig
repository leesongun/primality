const sprp = @import("sprp.zig").sprp2;

pub fn isprime_u32(p: u32) bool {
    const arr = [_]u64{ 2, 7, 61 };
    //safe because we test 2
    //if (p & 1 == 0) return p == 2;
    if (p <= 1) return false;
    return sprp(arr[0], p) and sprp(arr[1], p) and sprp(arr[2], p);
}

pub fn isprime_u64(p: u64) bool {
    const arr = [_]u64{ 2, 325, 9375, 28178, 450775, 9780504, 1795265022 };
    //safe because we test 2
    //if (p & 1 == 0) return p == 2;
    if (p <= 1) return false;
    inline for (arr) |i|
        if (!sprp(i, p)) return false;
    return true;
}

const vprp = @import("vprp.zig").vprp;

const jacobi = @import("jacobi.zig").jacobi;
const issquare = @import("util.zig").isoddsquare;
const candidates = @import("constant.zig").candidates;
pub fn isprime_vprp(p: u64) bool {
    if (p & 1 == 0 or p % 3 == 0 or p % 5 == 0)
        return p == 2 or p == 3 or p == 5; //thankfully, MAX_INTs get sieved here
    if (issquare(p)) return false;

    //should try inlined version
    const d = init: {
        var c: u64 = candidates;
        while (c != 0) : (c &= c - 1) {
            const t = 2 * @as(u64, @ctz(u64, c)) + 7;
            const u = p % t;
            if (u == 0) return p == t;
            if (jacobi(u, t) == 1) break :init t;
        }
        // unreachable;
        @panic("need longer list");
    };
    return vprp(p, d);
}
