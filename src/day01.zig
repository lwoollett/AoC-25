const std = @import("std");

const data = @embedFile("data/day01.txt");

const RotationResult = struct {
    new_position: i32,
    zero_crossings: i32,
};

/// Dial rotation
fn rotatePosition(dial: i32, direction: u8, value: i32) RotationResult {
    if (direction == 'R') {
        // Right rotation: add value to current position
        const sum = dial + value;
        const zeros_passed: i32 = @intCast(@divTrunc(@abs(sum), 100));
        const new_dial = @mod(sum, 100);
        return RotationResult{ .new_position = new_dial, .zero_crossings = zeros_passed };
    } else {
        // Left rotation: subtract value
        const inverted: i32 = if (dial > 0) 100 - dial else 0;
        const sum = inverted + value;
        const zeros_passed: i32 = @intCast(@divTrunc(@abs(sum), 100));

        const diff = dial - value;
        var new_dial = @mod(diff, 100);
        if (new_dial < 0) new_dial += 100;

        return RotationResult{ .new_position = new_dial, .zero_crossings = zeros_passed };
    }
}

pub fn main() !void {
    var score_p1: i32 = 0;
    var score_p2: i32 = 0;
    var current: i32 = 50;

    var lines = std.mem.tokenizeAny(u8, data, "\r\n");
    while (lines.next()) |line| {
        const direction = line[0];
        const amount = try std.fmt.parseInt(i32, line[1..], 10);

        const result = rotatePosition(current, direction, amount);
        current = result.new_position;
        score_p2 += result.zero_crossings;

        // Part 1: Count when dial lands on position 0
        if (current == 0) {
            score_p1 += 1;
        }
    }

    std.debug.print("Part 1 Password: {d}\n", .{score_p1});
    std.debug.print("Part 2 Password: {d}\n", .{score_p2});
}

// ! AI Generated tests cause lazy
// Tests for zero crossings during rotation
test "rotatePosition - L68 from 50 crosses zero once" {
    const result = rotatePosition(50, 'L', 68);
    try std.testing.expect(result.new_position == 82);
    try std.testing.expect(result.zero_crossings == 1);
}

test "rotatePosition - R60 from 95 crosses zero once" {
    const result = rotatePosition(95, 'R', 60);
    try std.testing.expect(result.new_position == 55);
    try std.testing.expect(result.zero_crossings == 1);
}

test "rotatePosition - basic functionality" {
    // Test right rotation without crossing zero
    const r1 = rotatePosition(25, 'R', 30);
    try std.testing.expect(r1.new_position == 55);
    try std.testing.expect(r1.zero_crossings == 0);

    // Test left rotation without crossing zero
    const r2 = rotatePosition(50, 'L', 20);
    try std.testing.expect(r2.new_position == 30);
    try std.testing.expect(r2.zero_crossings == 0);
}

// Generated from template/template.zig.
// Run `zig build generate` to update.
// Only unmodified days will be updated.
