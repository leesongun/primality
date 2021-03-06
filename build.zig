const std = @import("std");

pub fn build(b: *std.build.Builder) void {
    // Standard release options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall.
    const mode = b.standardReleaseOptions();

    const lib = b.addStaticLibrary("primality", "src/main.zig");
    lib.setBuildMode(mode);
    lib.install();

    const main_tests = b.addTest("src/test.zig");
    main_tests.setBuildMode(mode);

    const test_step = b.step("test", "Run library tests");
    test_step.dependOn(&main_tests.step);

    const comp_tests = b.addTest("src/compare.zig");
    comp_tests.setBuildMode(std.builtin.Mode.ReleaseFast);

    const bench_step = b.step("bench", "Run benchmark tests");
    bench_step.dependOn(&comp_tests.step);

    const comp_debug = b.addTest("src/compare.zig");
    comp_tests.setBuildMode(std.builtin.Mode.Debug);

    const debug_step = b.step("debug", "Run benchmark tests");
    debug_step.dependOn(&comp_debug.step);
}
