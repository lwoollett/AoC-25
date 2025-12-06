const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("data/day02.txt");

pub fn main() !void {
    var inranges = std.mem.tokenizeSequence(u8, data, ",");
    var part1_sum: i64 = 0;
    var part2_sum: i64 = 0;
    while (inranges.next()) |range| {
        var bounds = std.mem.splitSequence(u8, range, "-");
        const min = try std.fmt.parseInt(i64, bounds.next().?, 10);
        const max = try std.fmt.parseInt(i64, bounds.next().?, 10);
        part1_sum += sumSpecialNumbersOptimized(min, max);
        part2_sum += sumRepeatingNumbersOptimized(min, max);
    }

    std.debug.print("Part 1: {d}\n", .{part1_sum});
    std.debug.print("Part 2: {d}\n", .{part2_sum});
}

fn generateNextSpecialNumber(n: i64) i64 {
    // A "special number" is one where the number consists of two identical halves
    // Examples: 11, 2222, 1212, 123123

    var buf: [32]u8 = undefined;
    const str = std.fmt.bufPrint(&buf, "{d}", .{n}) catch unreachable;
    const len = str.len;

    // Take first half of digits
    const half_len = len / 2;
    if (half_len == 0) return 0;

    const first_half_str = str[0..half_len];

    // Generate number by repeating the first half
    var result_buf: [32]u8 = undefined;
    const result_str = std.fmt.bufPrint(&result_buf, "{s}{s}", .{ first_half_str, first_half_str }) catch unreachable;
    return std.fmt.parseInt(i64, result_str, 10) catch 0;
}

fn sumSpecialNumbersOptimized(start: i64, end: i64) i64 {
    if (start > end) return 0;

    var sum: i64 = 0;
    var n = generateNextSpecialNumber(start);

    // If n < start, find the next special number >= start
    while (n < start) {
        // Get the number from the first half of n
        var buf: [32]u8 = undefined;
        const str = std.fmt.bufPrint(&buf, "{d}", .{n}) catch break;
        const half_len = str.len / 2;
        if (half_len == 0) break;

        const first_half_str = str[0..half_len];
        const first_half = std.fmt.parseInt(i64, first_half_str, 10) catch break;

        // Increment the first half and generate new number
        const next_first_half = first_half + 1;
        const next_first_half_str = std.fmt.bufPrint(&buf, "{d}", .{next_first_half}) catch break;

        var result_buf: [32]u8 = undefined;
        const next_str = std.fmt.bufPrint(&result_buf, "{s}{s}", .{ next_first_half_str, next_first_half_str }) catch break;
        n = std.fmt.parseInt(i64, next_str, 10) catch break;
    }

    var iterations: usize = 0;
    const max_iterations = 10000;

    while (n <= end and iterations < max_iterations) {
        sum += n;

        // Generate next special number
        var buf: [32]u8 = undefined;
        const str = std.fmt.bufPrint(&buf, "{d}", .{n}) catch break;
        const half_len = str.len / 2;
        if (half_len == 0) break;

        const first_half_str = str[0..half_len];
        const first_half = std.fmt.parseInt(i64, first_half_str, 10) catch break;

        const next_first_half = first_half + 1;
        const next_first_half_str = std.fmt.bufPrint(&buf, "{d}", .{next_first_half}) catch break;

        var result_buf: [32]u8 = undefined;
        const next_str = std.fmt.bufPrint(&result_buf, "{s}{s}", .{ next_first_half_str, next_first_half_str }) catch break;
        n = std.fmt.parseInt(i64, next_str, 10) catch break;

        iterations += 1;
    }

    return sum;
}

fn isRepeatingNumber(n: i64) bool {
    var buf: [32]u8 = undefined;
    const str = std.fmt.bufPrint(&buf, "{d}", .{n}) catch return false;
    const len = str.len;

    if (len < 2) return false;

    // Check all possible pattern lengths
    var pattern_len: usize = 1;
    while (pattern_len <= len / 2) : (pattern_len += 1) {
        if (len % pattern_len != 0) continue;

        const pattern = str[0..pattern_len];
        var valid = true;

        var i: usize = pattern_len;
        while (i < len) : (i += pattern_len) {
            if (!std.mem.eql(u8, pattern, str[i .. i + pattern_len])) {
                valid = false;
                break;
            }
        }

        if (valid) return true;
    }

    return false;
}

fn sumRepeatingNumbersOptimized(start: i64, end: i64) i64 {
    if (start > end) return 0;

    var sum: i64 = 0;
    var current = start;

    // Early exit for small ranges - use simple loop
    if (end - start < 10000) {
        while (current <= end) : (current += 1) {
            if (isRepeatingNumber(current)) {
                sum += current;
            }
        }
        return sum;
    }

    // For larger ranges, we could add more sophisticated optimization
    // but the problem description suggests ranges are reasonable

    while (current <= end) : (current += 1) {
        if (isRepeatingNumber(current)) {
            sum += current;
        }
    }

    return sum;
}

// Tests remain the same as in your original code
test "11-22" {
    const res = sumSpecialNumbersOptimized(11, 22);
    try std.testing.expect(res == 33);
}

test "95-115" {
    const res = sumSpecialNumbersOptimized(95, 115);
    try std.testing.expect(res == 99);
}

test "998-1012" {
    const res = sumSpecialNumbersOptimized(998, 1012);
    try std.testing.expect(res == 1010);
}

test "1188511880-1188511890" {
    const res = sumSpecialNumbersOptimized(1188511880, 1188511890);
    try std.testing.expect(res == 1188511885);
}

test "222220-222224" {
    const res = sumSpecialNumbersOptimized(222220, 222224);
    try std.testing.expect(res == 222222);
}

test "1698522-1698528" {
    const res = sumSpecialNumbersOptimized(1698522, 1698528);
    try std.testing.expect(res == 0);
}

test "446443-446449" {
    const res = sumSpecialNumbersOptimized(446443, 446449);
    try std.testing.expect(res == 446446);
}

test "38593856-38593862" {
    const res = sumSpecialNumbersOptimized(38593856, 38593862);
    try std.testing.expect(res == 38593859);
}

test "isRepeatingNumber - 12341234" {
    try std.testing.expect(isRepeatingNumber(12341234) == true);
}

test "isRepeatingNumber - 123123123" {
    try std.testing.expect(isRepeatingNumber(123123123) == true);
}

test "isRepeatingNumber - 1212121212" {
    try std.testing.expect(isRepeatingNumber(1212121212) == true);
}

test "isRepeatingNumber - 1111111" {
    try std.testing.expect(isRepeatingNumber(1111111) == true);
}

test "isRepeatingNumber - 12345" {
    try std.testing.expect(isRepeatingNumber(12345) == false);
}

test "sumRepeatingNumbersOptimized - basic range" {
    const res = sumRepeatingNumbersOptimized(1111, 1234);
    try std.testing.expect(res == 2323); // 1111 + 1212
}
