const print = @import("std").debug.print;
const isp = @import("isprime.zig");

const isp1 = isp.isprime_u64;
const isp2 = isp.isprime_vprp;

test "compare results" {
    var i: u64 = 0;
    while (i < 0xFFFF_FFFF) {
        var a = isp1(i);
        var b = isp2(i);
        if (a != b) {
            print("{d}sprp:{}\tvprp:{}\t\n", .{ i, a, b });
        }
        if (i & 0x00FF_FFFF == 0x00FF_FFFF)
            print("done {X}\n", .{i});
        i += 1;
    }
}
