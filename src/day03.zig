const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("data/day03.txt");

pub fn main() !void {
    var batterycapacity: i64 = 0;
    var lines = std.mem.tokenizeAny(u8, data, "\r\n");
    while (lines.next()) |line| {
        // Convert line to []i8
        // ! TODO: Optimise alloc
        // ! Zig 15 ArrayList allocator is weird
        // ! Docs also aren't updated lmao
        var nums = try List(i8).initCapacity(gpa, 64);
        defer nums.deinit(gpa);
        // Each char in input is a digit
        for (line) |c| {
            const digit = @as(i8, @intCast(c - '0'));
            try nums.append(gpa, digit);
        }
        // Sort nums desc
        std.mem.sort(i8, nums.items, {}, std.sort.desc(i8));
        // Take first 2
        print("Top two digits: {d}, {d}\n", .{ nums.items[0], nums.items[1] });
        batterycapacity += nums.items[0] + nums.items[1];
        // * We're gucci gaming
    }
    print("Part 1 Result: {d}\n", .{batterycapacity});
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
