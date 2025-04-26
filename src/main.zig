const std = @import("std");
const c = @cImport({
    @cInclude("raylib.h");
    @cDefine("RAYGUI_IMPLEMENTATION", {});
    @cInclude("raygui.h");
});

pub fn main() !void {
    // TODO: make window dynamically sized
    // TODO: Listen for kill program keyboard shortcut
    // TODO: play video using ffmpeg
    const width = 800;
    const height = 450;
    const fps = 60;

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer std.debug.assert(gpa.deinit() == std.heap.Check.ok);

    c.InitWindow(width, height, "Whisper");
    c.SetTargetFPS(fps);
    var file_name: ?[]u8 = null;
    defer {
        if (file_name) |f| {
            allocator.free(f);
        }
    }

    while (!c.WindowShouldClose()) {
        // UPDATE
        // ---
        if (c.IsKeyPressed(c.KEY_Q) and (c.IsKeyDown(c.KEY_LEFT_CONTROL) or c.IsKeyDown(c.KEY_RIGHT_CONTROL) or c.IsKeyDown(c.KEY_LEFT_SUPER) or c.IsKeyDown(c.KEY_RIGHT_SUPER))) {
            break;
        }
        if (c.IsFileDropped()) {
            const droppedFiles = c.LoadDroppedFiles();
            defer c.UnloadDroppedFiles(droppedFiles);

            if (droppedFiles.count == 1) {
                if (file_name) |f| {
                    allocator.free(f);
                    file_name = null;
                }
                file_name = try allocator.dupe(u8, std.mem.span(droppedFiles.paths[0]));
            }
        }
        // ---

        // DRAW
        // ---
        c.BeginDrawing();
        c.ClearBackground(c.GetColor(@as(c_uint, @bitCast(c.GuiGetStyle(c.DEFAULT, c.BACKGROUND_COLOR)))));
        if (file_name) |f| {
            c.DrawText("Dropped files:", 100, 40, 20, c.DARKGRAY);
            c.DrawRectangle(0, 85, width, height, c.Fade(c.LIGHTGRAY, 0.5));
            c.DrawText(f.ptr, 120, 100, 10, c.GRAY);

            if (c.GuiButton(c.Rectangle{ .x = width / 2 - 250, .y = 300, .width = 100, .height = 50 }, "Run") != 0) {
                allocator.free(f);
                file_name = null;
            }

            if (c.GuiButton(c.Rectangle{ .x = width / 2 + 150, .y = 300, .width = 100, .height = 50 }, "Cancel") != 0) {
                allocator.free(f);
                file_name = null;
            }
        } else {
            c.DrawText("Please only drop a single file in the window", 100, 40, 20, c.DARKGRAY);
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
