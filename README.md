# zig-time

This is a fork of [zig-time](https://github.com/nektro/zig-time) that's uses Zig's native packaging instead of
[zigmod](https://github.com/nektro/zigmod).

## Usage

Add this repository to your `build.zig.zon`, eg:
```zon
// build.zig.zon
.{
    .name = "awesome-project",
    .version = "0.1.0",
    .minimum_zig_version = "0.12.0",
    .paths = .{ "" },
    .dependencies = .{
        .zig_time = .{
            .url = "git+https://github.com/Protonull/zig-time#<COMMIT HASH>",
            .hash = "<HASH>" // Comment this out Zig will automatically tell you what has to use.
        },
    },
}
```

After that, add the dependency to your build script, eg:

```zig
// build.zig
const std = @import("std");

pub fn build(
    b: *std.Build
) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{
        .name = "awesome-project",
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });

    // zig-time dependency goes here
    exe.root_module.addImport("zig-time", b.dependency("zig_time", .{}).module("time"));
    
    b.installArtifact(exe);
}
```

You may notice there's `zig-time`, `zig_time`, and `time`.

- `zig-time` is what you'd use as the import, like so: `const time = @import("zig-time")`
- `zig_time` is the key to match in `build.zig.zon`, which doesn't like dashes.
- `time` is the name of the exported module from zig-time, the library itself.
