const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const time_mod = b.addModule("time", .{
        .root_source_file = .{ .path = "time.zig" },
        .target = target,
        .optimize = optimize,
    });
    time_mod.addImport("extras", b.dependency("zig_extras", .{}).module("extras"));

    const main_as_test = b.addTest(.{
        .root_source_file = .{ .path = "main.zig" },
        .target = target,
        .optimize = optimize,
    });
    main_as_test.root_module.addImport("time", time_mod);
    const run_unit_tests = b.addRunArtifact(main_as_test);
    b.step("test", "Run unit tests").dependOn(&run_unit_tests.step);
}
