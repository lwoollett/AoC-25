const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("data/day06.txt");

const Problem = struct {
    input: []u32,
    input_rtl: []u32,
    operator: u8,
};

pub fn main() !void {
    var lines = std.mem.splitAny(u8, data, "\r\n");
    var problems = try List(Problem).initCapacity(gpa, 256);
    var total: u64 = 0;
    var total_rtl: u64 = 0;
    defer {
        for (problems.items) |problem| gpa.free(problem.input);
        problems.deinit(gpa);
    }

    var grid = try List([]u32).initCapacity(gpa, 256);
    defer {
        for (grid.items) |row| gpa.free(row);
        grid.deinit(gpa);
    }

    // Parse each line into numbers
    while (lines.next()) |line| {
        if (line.len == 0) continue;

        var tokens = tokenizeSeq(u8, line, " ");
        var row = try List(u32).initCapacity(gpa, 16);

        // When parsing the operators row
        while (tokens.next()) |token| {
            if (token.len == 1 and (token[0] == '+' or token[0] == '*')) {
                const op: u8 = token[0];
                try row.append(gpa, op);
            } else {
                const num = try std.fmt.parseInt(u32, token, 10);
                try row.append(gpa, num);
            }
        }

        // Ensure all rows have the same number of columns
        if (grid.items.len > 0 and row.items.len != grid.items[0].len) {
            print("Error: Row {d} has {d} columns, expected {d}\n", .{ grid.items.len + 1, row.items.len, grid.items[0].len });
            return error.InvalidInput;
        }

        try grid.append(gpa, try row.toOwnedSlice(gpa));
    }

    if (grid.items.len == 0) {
        print("No data found\n", .{});
        return;
    }

    const num_rows = grid.items.len;
    const num_cols = grid.items[0].len;

    // Last row contains operators (+ or *)
    if (num_rows < 2) {
        print("Need at least 2 rows (inputs + operators)\n", .{});
        return error.InvalidInput;
    }

    const operators_row = grid.items[num_rows - 1];

    // Process each column into a problem
    for (0..num_cols) |col_idx| {
        var input_numbers = try List(u32).initCapacity(gpa, num_rows - 1);
        var input_rtl = try List(u32).initCapacity(gpa, num_rows - 1);

        var max_digits: u32 = 0;

        // Collect input numbers from each row except the last
        for (0..num_rows - 1) |row_idx| {
            const num = grid.items[row_idx][col_idx];
            try input_numbers.append(gpa, num);
            const xx: u32 = @intCast(std.math.log10_int(num));
            if (xx > max_digits) {
                max_digits = xx;
            }
        }

        // for (0..num_rows - 1) |row_idx| {
        //     const num = input_numbers.items[row_idx];
        //     var digit_buf: [32]u8 = undefined;
        //     const num_str = std.fmt.bufPrint(&digit_buf, "{d}", .{num}) catch unreachable;

        //     // Pad with following -'s to max_digits
        //     var padded: [32]u8 = undefined;
        //     const padding_needed: u32 = max_digits - @as(u32, num_str.len);
        //     for (padding_needed..max_digits) |i| {
        //         padded[i] = '-';
        //     }
        // }
        // Initialize grid for RTL representation

        // Now we have a max digits, we can create RTL numbers
        // Read each column, using a nested array to store digits
        // for (0..num_rows - 1) |row_index| {
        //     const num = input_numbers.items[row_index];
        // }

        const operator_char = operators_row[col_idx];
        const operator: u8 = switch (operator_char) {
            0 => '+',
            1 => '*',
            else => @as(u8, @intCast(operator_char)),
        };

        try problems.append(gpa, Problem{
            .input = try input_numbers.toOwnedSlice(gpa),
            .input_rtl = try input_rtl.toOwnedSlice(gpa),
            .operator = operator,
        });
    }

    // Solve and print results
    for (problems.items, 0..) |problem, idx| {
        const result = switch (problem.operator) {
            '+' => blk: {
                var sum: u64 = 0;
                for (problem.input) |num| sum += num;
                break :blk sum;
            },
            '*' => blk: {
                var product: u64 = 1;
                for (problem.input) |num| product *= num;
                break :blk product;
            },
            else => {
                print("Unknown operator '{c}' (value {d}) in problem {d}\n", .{ problem.operator, problem.operator, idx + 1 });
                continue;
            },
        };

        const rtl_res = switch (problem.operator) {
            '+' => blk: {
                var sum: u64 = 0;
                for (problem.input_rtl) |num| sum += num;
                break :blk sum;
            },
            '*' => blk: {
                var product: u64 = 1;
                for (problem.input_rtl) |num| product *= num;
                break :blk product;
            },
            else => 0,
        };

        total += result;
        total_rtl += rtl_res;
    }
    print("Part 1: {d}\n", .{total});
    print("Part 2: {d}\n", .{total_rtl});
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
