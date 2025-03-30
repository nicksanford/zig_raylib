const std = @import("std");
const c = @cImport(@cInclude("raylib.h"));
pub fn main() !void {
    const width = 800;
    const height = 450;
    const fps = 60;

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer std.debug.assert(gpa.deinit() == .ok);

    var list = std.ArrayList([]u8).init(allocator);
    defer list.deinit();

    c.InitWindow(width, height, "drop files");
    c.SetTargetFPS(fps);
    // std.ArrayList(comptime T: type)
    while (!c.WindowShouldClose()) {
        // UPDATE
        // ---
        if (c.IsFileDropped()) {
            const droppedFiles = c.LoadDroppedFiles();
            defer c.UnloadDroppedFiles(droppedFiles);

            for (0..droppedFiles.count) |i| {
                const x = try allocator.dupeZ(u8, std.mem.span(droppedFiles.paths[i]));
                // const x = try allocator.dupeZ();
                try list.append(x);
            }
        }
        // ---

        // DRAW
        // ---
        c.BeginDrawing();

        c.ClearBackground(c.RAYWHITE);
        if (list.items.len == 0) {
            c.DrawText("Drop files into the window!!!", 100, 40, 20, c.DARKGRAY);
        } else {
            c.DrawText("Dropped files:", 100, 40, 20, c.DARKGRAY);
            for (0.., list.items) |i, file| {
                const fademod: f32 = if (i % 2 == 0) 0.5 else 0.3;
                c.DrawRectangle(0, @as(c_int, @intCast(85 + 40 * i)), width, height, c.Fade(c.LIGHTGRAY, fademod));
                c.DrawText(file.ptr, 120, @as(c_int, @intCast(100 + 40 * i)), 10, c.GRAY);
            }
            c.DrawText("Drop new files...", 100, @as(c_int, @intCast(110 + 40 * list.items.len)), 20, c.DARKGRAY);
        }

        c.EndDrawing();
        // ---
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
