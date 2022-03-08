const print = @import("std").debug.print;
const isprime = @import("./main.zig").isprime;
pub fn main() void {
    var i: u32 = 0;
    while (i < 100) {
        if (isprime(i)) {
            print("{d}\n", .{i});
        }
        i += 1;
    }
}
