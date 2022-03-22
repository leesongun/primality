const print = @import("std").debug.print;
const isp = @import("isprime.zig");

const isp1 = isp.isprime_u64;
const isp2 = isp.isprime_vprp;

test "compare results" {
    var i: u64 = 0;
    var count: u64 = 0;
    while (i < 0xFFFF_FFFF) : (i += 1) {
        var a = isp1(i);
        var b = isp2(i);
        if (a != b) {
            print("{d}sprp:{}\tvprp:{}\t\n", .{ i, a, b });
            count += 1;
        }
        if (i & 0x00FF_FFFF == 0x00FF_FFFF)
            print("done {X}\n", .{i});
    }
    try @import("std").testing.expectEqual(@as(u64, 0), count);
}
