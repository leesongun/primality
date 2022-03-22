pub fn half(a: u64, b: u64) u64 {
    assert(b & 1 == 1);
    const c = @truncate(u1, a);
    return b - (b >> c) + (a >> 1);
}

pub fn highbit(a: u64) u64 {
    return @as(u64, 1) << ~@intCast(u6, @clz(u64, a));
}
