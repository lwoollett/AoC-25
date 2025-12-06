const std = @import("std");
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("data/day04.txt");

const Coords = struct {
    x: usize,
    y: usize,
    value: bool,
};

// This is a tricky one to think about
// I reckon we do [][] as the grid
// Maybe do a helper function to check neighbors?
fn checkNeighbors(grid: []ArrayList(Coords), coords: Coords, limit: u8) bool {
    const width = grid[coords.x].items.len;
    const height = grid.len;
    // ***** Neighbor offsets ******
    // ? x x x --- -1,-1, -1,0, -1,1
    // ? x o x ---  0,-1,        0,1
    // ? x x x ---  1,-1,  1,0,  1,1
    // *****************************
    var count: i8 = 0;

    // Define bounds (clamped to grid edges)
    const start_x = if (coords.x == 0) 0 else coords.x - 1;
    const end_x = @min(coords.x + 1, height - 1);
    const start_y = if (coords.y == 0) 0 else coords.y - 1;
    const end_y = @min(coords.y + 1, width - 1);

    // Iterate through valid neighbors
    for (start_x..end_x + 1) |x| {
        for (start_y..end_y + 1) |y| {
            if (x == coords.x and y == coords.y) {
                continue;
            }

            if (grid[x].items[y].value) {
                count += 1;
                if (count >= limit) {
                    return false;
                }
            }
        }
    }

    return true;
}

pub fn main() !void {
    const limit: u8 = 4;
    var lines = std.mem.tokenizeAny(u8, data, "\r\n");
    var count: usize = 0;
    var grid = try ArrayList(ArrayList(Coords)).initCapacity(gpa, 512);
    defer grid.deinit(gpa);
    while (lines.next()) |line| {
        var row = try ArrayList(Coords).initCapacity(gpa, 512);
        for (line, 0..) |c, i| {
            if (c == '.') {
                try row.append(gpa, Coords{ .x = count, .y = i, .value = false });
            } else {
                try row.append(gpa, Coords{ .x = count, .y = i, .value = true });
            }
        }
        try grid.append(gpa, row);
        count += 1;
    }
    // Now we have the grid, we can process it
    var paper_rolls: i16 = 0;
    var paper_rolls_removed: i16 = 0;
    var paper_rolls_removed_current: i16 = -1;

    // ! Leave part one as is
    for (grid.items) |row| {
        for (row.items, 0..) |cell, j| {
            if (cell.value and checkNeighbors(grid.items, cell, limit)) {
                paper_rolls += 1;
                paper_rolls_removed += 1;
                row.items[j].value = false;
            }
        }
    }

    // * Just wrap it in a while loop until we can't move any more paper
    while (paper_rolls_removed_current != 0) {
        paper_rolls_removed_current = 0;
        for (grid.items) |row| {
            for (row.items, 0..) |cell, j| {
                if (cell.value and checkNeighbors(grid.items, cell, limit)) {
                    paper_rolls_removed += 1;
                    paper_rolls_removed_current += 1;
                    row.items[j].value = false;
                }
            }
        }
    }

    print("Part 1: {d}\n", .{paper_rolls});
    print("Part 2: {d}\n", .{paper_rolls_removed});
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
