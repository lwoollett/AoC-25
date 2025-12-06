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
    var batterycapacity: i64 = 0;
    var lines = std.mem.tokenizeAny(u8, data, "\r\n");
    while (lines.next()) |line| {
        // Convert line to []i8
        batterycapacity += try getVoltageForLine(line);
    }
    print("Part 1 Result: {d}\n", .{batterycapacity});
}

fn getVoltageForLine(line: []const u8) !i64 {
    // ! TODO: Optimise alloc (probably less than 64 on input)
    // ! Zig 15 ArrayList allocator is weird
    // ! Docs also aren't updated lmao
    var nums = try List(i8).initCapacity(gpa, 128);
    defer nums.deinit(gpa);
    // Each char in input is a digit
    for (line) |c| {
        const digit = @as(i8, @intCast(c - '0'));
        try nums.append(gpa, digit);
    }
    // !! We're not allowed to sort the input array
    // So we have to find the top two digits manually
    var first_max: numWithIdx = .{ .num = -1, .index = -1 };
    var second_max: numWithIdx = .{ .num = -1, .index = -1 };
    // We want to optimise to get the highest number possible as the first, with the second number being a lesser prize
    // Second_max has to be AFTER first_max in the input list
    // Do two passes to find first and second max
    // First max has to have at least one number after it
    var idx: i8 = 0;
    for (nums.items[0 .. nums.items.len - 1]) |n| {
        if (n > first_max.num) {
            first_max = .{ .num = n, .index = @as(i8, idx) };
        }
        idx += 1;
    }
    idx = 0;
    for (nums.items[@as(usize, @intCast(first_max.index + 1))..]) |n| {
        if (n > second_max.num) {
            second_max = .{ .num = n, .index = @as(i8, idx) };
        }
        idx += 1;
    }
    print("Top two digits: {d}, {d}\n", .{ first_max.num, second_max.num });
    // Instead of doing weird string shit just x10 the first val
    return (first_max.num * 10) + second_max.num;
    // * We're gucci gaming
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
