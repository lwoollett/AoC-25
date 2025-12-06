const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("data/day01.txt");

pub fn main() !void {
    const boundMax = 99;
    const boundMin = 0;
    var score: i16 = 0;
    var score_p2: i16 = 0;
    var current: i32 = 50;

    // Load file data as array of lines
    var lines = tokenizeAny(u8, data, "\r\n");

    // For Line in lines
    while (lines.next()) |line| {
        var lineScore = 0;
        // Split first char of line, parse second half as int
        // Do we bother using like.. int16 here or something?
        const l_or_r = line[0..1];
        const init_val = try std.fmt.parseInt(i32, line[1..], 10);
        // ! Rotation Logic
        if (std.mem.eql(u8, l_or_r, "L")) {
            if (current + init_val >= 100) {
                if (current + init_val == 100) {
                    print("Exact 100 Detected\n", .{});
                    // No change
                } else {
                    // We now have to figure out how many times we've overflowed to adjust the score
                    const overflows = (current + init_val) / 100;
                    print("Overflows Detected: {d}\n", .{overflows});
                    lineScore += parseInt(i16, overflows);
                }
                // Over / Under flow Detected
            }
            current = @mod(current - init_val, 100);
            print("Move Left {d} from {d} to {d}\n", .{ init_val, current + init_val, current });
        } else if (std.mem.eql(u8, l_or_r, "R")) {
            current = @mod(current + init_val, 100);
            print("Move Right {d} from {d} to {d}\n", .{ init_val, current - init_val, current });
        }
        // Now we need to check if the result is 0
        if (current == 0) {
            print("Current is 0, Adding Point\n", .{});
            score += 1;
        }

        score_p2 += lineScore;
    }

    score_p2 += score;

    print("Password: {d}\n", .{score});
    print("Part 2 Password: {d}\n", .{score_p2});
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
