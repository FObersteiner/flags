const Terminal = @This();

const std = @import("std");
const ColorScheme = @import("ColorScheme.zig");

const tty = std.Io.Terminal;
const File = std.Io.File;

writer: *std.Io.Writer,
t: tty,

pub fn init(io: std.Io, file: File, writer: *std.Io.Writer) !Terminal {
    const terminal_mode: std.Io.Terminal.Mode = try .detect(io, file, false, false);
    return .{
        .writer = writer,
        .t = .{ .writer = writer, .mode = terminal_mode },
    };
}

pub fn print(
    terminal: Terminal,
    style: ColorScheme.Style,
    comptime format: []const u8,
    args: anytype,
) void {
    for (style) |color| {
        terminal.t.setColor(color) catch {};
    }

    terminal.writer.print(format, args) catch {};

    if (style.len > 0) {
        terminal.t.setColor(.reset) catch {};
    }
}
