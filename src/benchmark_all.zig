const std = @import("std");
const Allocator = std.mem.Allocator;

// Import day modules
const day01 = @import("day01.zig");
const day02 = @import("day02.zig");
const day03 = @import("day03.zig");
const day04 = @import("day04.zig");
const day05 = @import("day05.zig");
const day06 = @import("day06.zig");

const BenchmarkResult = struct {
    day: u8,
    avg_time_ns: u64,
    min_time_ns: u64,
    max_time_ns: u64,
    total_time_ns: u64,
};

fn benchmarkDay(comptime day_num: u8, comptime day_main: fn () anyerror!void, runs: u32) !BenchmarkResult {
    var times = try std.ArrayList(u64).initCapacity(std.heap.page_allocator, runs);
    defer times.deinit(std.heap.page_allocator);

    var total_time: u64 = 0;
    var min_time: u64 = std.math.maxInt(u64);
    var max_time: u64 = 0;

    // Warm up run (not counted)
    _ = day_main() catch {};

    for (0..runs) |_| {
        const start_time = std.time.nanoTimestamp();
        _ = day_main() catch {};
        const end_time = std.time.nanoTimestamp();

        const duration = @as(u64, @intCast(end_time - start_time));
        try times.append(std.heap.page_allocator, duration);

        total_time += duration;
        min_time = @min(min_time, duration);
        max_time = @max(max_time, duration);
    }

    const avg_time = total_time / runs;

    return BenchmarkResult{
        .day = day_num,
        .avg_time_ns = avg_time,
        .min_time_ns = min_time,
        .max_time_ns = max_time,
        .total_time_ns = total_time,
    };
}

fn formatTime(ns: u64, buf: []u8) []const u8 {
    if (ns >= 1_000_000_000) {
        // Seconds
        const len = std.fmt.bufPrint(buf, "{d:.3}s", .{@as(f64, @floatFromInt(ns)) / 1_000_000_000.0}) catch unreachable;
        return len;
    } else if (ns >= 1_000_000) {
        // Milliseconds
        const len = std.fmt.bufPrint(buf, "{d:.3}ms", .{@as(f64, @floatFromInt(ns)) / 1_000_000.0}) catch unreachable;
        return len;
    } else if (ns >= 1_000) {
        // Microseconds
        const len = std.fmt.bufPrint(buf, "{d:.3}μs", .{@as(f64, @floatFromInt(ns)) / 1_000.0}) catch unreachable;
        return len;
    } else {
        // Nanoseconds
        const len = std.fmt.bufPrint(buf, "{d}ns", .{ns}) catch unreachable;
        return len;
    }
}

pub fn main() !void {
    const runs = 5;
    std.debug.print("🏃 Running Advent of Code 2025 Benchmarks\n", .{});
    std.debug.print("Running each solution {d} times...\n\n", .{runs});

    var results = try std.ArrayList(BenchmarkResult).initCapacity(std.heap.page_allocator, 5);
    defer results.deinit(std.heap.page_allocator);

    // Benchmark each day
    std.debug.print("Day 01... \n", .{});
    const day01_result = try benchmarkDay(1, day01.main, runs);
    try results.append(std.heap.page_allocator, day01_result);
    std.debug.print("✓\n", .{});

    std.debug.print("Day 02... \n", .{});
    const day02_result = try benchmarkDay(2, day02.main, runs);
    try results.append(std.heap.page_allocator, day02_result);
    std.debug.print("✓\n", .{});

    std.debug.print("Day 03... \n", .{});
    const day03_result = try benchmarkDay(3, day03.main, runs);
    try results.append(std.heap.page_allocator, day03_result);
    std.debug.print("✓\n", .{});

    std.debug.print("Day 04... \n", .{});
    const day04_result = try benchmarkDay(4, day04.main, runs);
    try results.append(std.heap.page_allocator, day04_result);
    std.debug.print("✓\n", .{});

    std.debug.print("Day 05... \n", .{});
    const day05_result = try benchmarkDay(5, day05.main, runs);
    try results.append(std.heap.page_allocator, day05_result);
    std.debug.print("✓\n", .{});

    std.debug.print("Day 06... \n", .{});
    const day06_result = try benchmarkDay(6, day06.main, runs);
    try results.append(std.heap.page_allocator, day06_result);
    std.debug.print("✓\n", .{});

    // Print results table
    std.debug.print("\n📊 Benchmark Results\n", .{});
    std.debug.print("╭─────────┬─────────────┬─────────────┬─────────────┬─────────────╮\n", .{});
    std.debug.print("│   Day   │   Average   │    Min      │    Max      │   Total     │\n", .{});
    std.debug.print("├─────────┼─────────────┼─────────────┼─────────────┼─────────────┤\n", .{});

    var avg_buf: [16]u8 = undefined;
    var min_buf: [16]u8 = undefined;
    var max_buf: [16]u8 = undefined;
    var total_buf: [16]u8 = undefined;

    for (results.items) |result| {
        const avg_str = formatTime(result.avg_time_ns, &avg_buf);
        const min_str = formatTime(result.min_time_ns, &min_buf);
        const max_str = formatTime(result.max_time_ns, &max_buf);
        const total_str = formatTime(result.total_time_ns, &total_buf);

        std.debug.print("│   {:0>2}    │ {s:>9}   │ {s:>9}   │ {s:>9}   │ {s:>9}   │\n", .{ result.day, avg_str, min_str, max_str, total_str });
    }

    std.debug.print("╰─────────┴─────────────┴─────────────┴─────────────┴─────────────╯\n", .{});

    // Calculate total time
    var total_avg_time: u64 = 0;
    for (results.items) |result| {
        total_avg_time += result.avg_time_ns;
    }

    var total_avg_buf: [16]u8 = undefined;
    std.debug.print("\n⏱️  Total average execution time: {s}\n", .{formatTime(total_avg_time, &total_avg_buf)});
    std.debug.print("🎯 All benchmarks completed successfully!\n", .{});
}
