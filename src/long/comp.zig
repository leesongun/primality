const sprp = @import("./sprp.zig").sprp2;

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
    return sprp(arr[0], p) and sprp(arr[1], p) and sprp(arr[2], p);
}
