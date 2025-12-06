const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("data/day03.txt");

const numWithIdx = struct {
    num: i8,
    index: i8,
};

pub fn main() !void {
    var batterycapacityp1: i64 = 0;
    var batterycapacityp2: i64 = 0;
    var lines = std.mem.tokenizeAny(u8, data, "\r\n");
    while (lines.next()) |line| {
        // Convert line to []i8
        batterycapacityp1 += try getVoltageForLine(line, 2);
        batterycapacityp2 += try getVoltageForLine(line, 12);
    }
    print("Part 1 Result: {d}\n", .{batterycapacityp1});
    print("Part 2 Result: {d}\n", .{batterycapacityp2});
}

fn getVoltageForLine(line: []const u8, keep: i8) !i64 {

    // Use ArrayList(u8) for stack of digits (as integers 0-9)
    var stack = try std.ArrayList(u8).initCapacity(gpa, 128);
    defer stack.deinit(gpa);

    const len = line.len;
    for (line, 0..) |c, i| {
        const digit = c - '0'; // ASCII to digit value
        const remaining = len - i;

        while (stack.items.len > 0 and
            digit > stack.items[stack.items.len - 1] and
            stack.items.len + (remaining - 1) >= keep)
        {
            _ = stack.pop();
        }

        try stack.append(gpa, digit);
    }

    const selected = stack.items[0..@as(usize, @intCast(keep))];

    // Parse to i64
    var result: i64 = 0;
    for (selected) |digit| {
        result = result * 10 + digit;
    }

    return result;
}

// Useful stdlib functions
const tokenizeAny = std.mem.tokenizeAny;
const tokenizeSeq = std.mem.tokenizeSequence;
const tokenizeSca = std.mem.tokenizeScalar;
const splitAny = std.mem.splitAny;
const splitSeq = std.mem.splitSequence;
const splitSca = std.mem.splitScalar;
const indexOf = std.mem.indexOfScalar;
const indexOfAny = std.mem.indexOfAny;
const indexOfStr = std.mem.indexOfPosLinear;
const lastIndexOf = std.mem.lastIndexOfScalar;
const lastIndexOfAny = std.mem.lastIndexOfAny;
const lastIndexOfStr = std.mem.lastIndexOfLinear;
const trim = std.mem.trim;
const sliceMin = std.mem.min;
const sliceMax = std.mem.max;

const parseInt = std.fmt.parseInt;
const parseFloat = std.fmt.parseFloat;

const print = std.debug.print;
const assert = std.debug.assert;

const sort = std.sort.block;
const asc = std.sort.asc;
const desc = std.sort.desc;

// Generated from template/template.zig.
// Run `zig build generate` to update.
// Only unmodified days will be updated.
