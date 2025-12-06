const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("data/day05.txt");

const Range = struct {
    start: i64,
    end: i64,
};

pub fn main() !void {
    var lines = std.mem.splitAny(u8, data, "\r\n");
    var ranges: List(Range) = try List(Range).initCapacity(gpa, 512);
    var halfway: bool = false;
    var fresh: u16 = 0;
    while (lines.next()) |line| {
        // There's a blank line between the ranges and the values
        if (line.len == 0) {
            print("Woah, we're halfway there!\n", .{});
            halfway = true;
            // Sort the ranges by start value for efficient processing
            std.mem.sort(Range, ranges.items, {}, struct {
                fn lessThan(_: void, a: Range, b: Range) bool {
                    return a.start < b.start;
                }
            }.lessThan);
            print("Sorted {d} ranges\n", .{ranges.items.len});
            continue;
        }
        // Parse range lines
        if (!halfway) {
            var parts = splitSeq(u8, line, "-");

            const start = try parseInt(i64, parts.next().?, 10);
            const end = try parseInt(i64, parts.next().?, 10);

            try ranges.append(gpa, Range{ .start = start, .end = end });
        } else {
            // Parse value lines
            const value = try std.fmt.parseInt(i64, line, 10);

            var itemfresh: bool = false;
            for (ranges.items) |range| {
                if (itemfresh) break;
                if (value >= range.start and value <= range.end) {
                    itemfresh = true;
                    break;
                }
            }
            fresh += if (itemfresh) 1 else 0;
        }
    }

    // Merge overlapping ranges
    var merged_ranges: List(Range) = try List(Range).initCapacity(gpa, ranges.items.len);
    for (ranges.items) |range| {
        if (range.start > range.end) {
            // Invalid range, skip
            continue;
        }

        if (merged_ranges.items.len == 0) {
            try merged_ranges.append(gpa, range);
            continue;
        }
        const last = &merged_ranges.items[merged_ranges.items.len - 1];
        if (range.start <= last.end + 1) {
            // Ranges overlap or are adjacent
            if (range.end > last.end) {
                last.end = range.end;
            }
        } else {
            try merged_ranges.append(gpa, range);
        }
    }

    // Count total unique IDs
    var total_count: u64 = 0;
    for (merged_ranges.items) |range| {
        if (range.start < 0 or range.end < range.start) {
            continue;
        }
        const count = @as(u64, @intCast(range.end - range.start + 1));
        total_count += count;
    }

    print("Part 1: {d}\n", .{fresh});
    print("Part 2: {d}\n", .{total_count});
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
