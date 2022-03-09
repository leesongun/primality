const print = @import("std").debug.print;

const isp1 = @import("sprp.zig").isprime;
const isp2 = @import("main.zig").isprime;

pub fn main() void {
    var i: u32 = 0;
    while (true) {
        var a = isp1(i);
        var b = isp2(i);
        if (a != b) {
            print("{d}sprp:{}\tvprp:{}\t\n", .{ i, a, b });
        }
        // if (i & 0xFFFF == 0xFFFF)
        //     print("done {h} {}\n", .{i, true});
        i += 1;
        if (i == 0) break;
    }
}
