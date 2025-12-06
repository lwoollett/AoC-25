const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("data/day01.txt");

const RotationResult = struct {
    new_position: i32,
    zero_crossings: i32,
};

/// Dial rotation logic
fn rotatePosition(current_pos: i32, direction: u8, amount: i32) RotationResult {
    var zero_crossings: i32 = 0;
    var new_pos: i32 = 0;

    const overf = @divTrunc(amount, 100);
    zero_crossings += overf;
    const new_am = @mod(amount, 100);

    if (direction == 'L') {
        // Calculate how many times we cross 0 going left
        if (new_am > current_pos) {
            zero_crossings += 1;
        }
        var overby = current_pos - new_am;
        if (overby < 0) {
            overby += 100;
        }
        new_pos = overby;
    } else if (direction == 'R') {
        if (current_pos + new_am > 100) {
            zero_crossings += 1;
        }
        new_pos = @mod(current_pos + new_am, 100);
    }

    return RotationResult{
        .new_position = new_pos,
        .zero_crossings = zero_crossings,
    };
}

/// Determines if the current position should increment the score
/// Returns true if position equals 0
fn shouldScore(position: i32) bool {
    return position == 0;
}

pub fn main() !void {
    var score_p1: i32 = 0;
    var score_p2: i32 = 0;
    var current: i32 = 50;

    // Load file data as array of lines
    var lines = tokenizeAny(u8, data, "\r\n");

    // For Line in lines
    while (lines.next()) |line| {
        // Split first char of line, parse second half as int
        const direction = line[0];
        const amount = try std.fmt.parseInt(i32, line[1..], 10);

        // Apply rotation logic
        const result = rotatePosition(current, direction, amount);
        current = result.new_position;
        score_p2 += result.zero_crossings;

        // Apply scoring logic
        if (current == 0) {
            // print("Current is 0, Adding Point\n", .{});
            score_p1 += 1;
        }
    }

    // Final score calc (short for calculator btw)
    score_p2 += score_p1;

    print("Part 1 Password: {d}\n", .{score_p1});
    print("Part 2 Password: {d}\n", .{score_p2});
}

// Tests for zero crossings during rotation
test "rotatePosition - L68 from 50 crosses zero once" {
    // Example: L68 from 50 goes 50→49→...→0→99→...→82, crossing 0 once
    const result = rotatePosition(50, 'L', 68);
    assert(result.new_position == 82);
    assert(result.overflows == 1); // Should cross 0 once during rotation
}

test "rotatePosition - R60 from 95 crosses zero once" {
    // Example: R60 from 95 goes 95→96→...→99→0→1→...→55, crossing 0 once
    const result = rotatePosition(95, 'R', 60);
    assert(result.new_position == 55);
    assert(result.overflows == 1); // Should cross 0 once during rotation
}

test "rotatePosition - L82 from 14 crosses zero once" {
    // Example: L82 from 14 goes 14→13→...→1→0→99→...→32, crossing 0 once
    const result = rotatePosition(14, 'L', 82);
    assert(result.new_position == 32);
    assert(result.overflows == 1); // Should cross 0 once during rotation
}

test "rotatePosition - R1000 from 50 crosses zero ten times" {
    const result = rotatePosition(50, 'R', 1000);
    assert(result.new_position == 50); // Returns to starting position
    assert(result.overflows == 10); // Should cross 0 ten times during rotation
}

test "rotatePosition - no zero crossing" {
    // Example: R10 from 50 goes 50→51→...→60, never crossing 0
    const result = rotatePosition(50, 'R', 10);
    assert(result.new_position == 60);
    assert(result.overflows == 0); // Should not cross 0 during rotation
}

test "rotatePosition - L30 from 82 no zero crossing" {
    // Example: L30 from 82 goes 82→81→...→52, never crossing 0
    const result = rotatePosition(82, 'L', 30);
    assert(result.new_position == 52);
    assert(result.overflows == 0); // Should not cross 0 during rotation
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
