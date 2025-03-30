const std = @import("std");
const c = @cImport(@cInclude("raylib.h"));
pub fn main() void {
    const width = 800;
    const height = 450;
    const fps = 60;
    c.InitWindow(width, height, "example [basic window]");
    c.SetTargetFPS(fps);
    while (!c.WindowShouldClose()) {
        c.BeginDrawing();
        c.ClearBackground(c.RAYWHITE);
        c.DrawText("Congrats! You made your first window!!!", 190, 200, 20, c.LIGHTGRAY);
        c.EndDrawing();
    }

    c.CloseWindow();
}

test "simple test" {
    // var list = std.ArrayList(i32).init(std.testing.allocator);
    // defer list.deinit(); // Try commenting this out and see if zig detects the memory leak!
    // try list.append(42);
    // try std.testing.expectEqual(@as(i32, 42), list.pop());
}

test "use other module" {
    // try std.testing.expectEqual(@as(i32, 150), lib.add(100, 50));
}

test "fuzz example" {
    // const Context = struct {
    //     fn testOne(context: @This(), input: []const u8) anyerror!void {
    //         _ = context;
    //         // Try passing `--fuzz` to `zig build test` and see if it manages to fail this test case!
    //         try std.testing.expect(!std.mem.eql(u8, "canyoufindme", input));
    //     }
    // };
    // try std.testing.fuzz(Context{}, Context.testOne, .{});
}
