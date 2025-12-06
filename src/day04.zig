const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("data/day04.txt");

const Coords = struct {
    x: usize,
    y: usize,
};

// This is a tricky one to think about
// I reckon we do [][] as the grid
// Maybe do a helper function to check neighbors?

fn checkNeighbors(grid: [][]u8, coords: Coords, limit: u8) bool {
    // Placeholder implementation
    var grid_h: usize = grid.len;
    var grid_w: usize = grid[coords.x].len;
    // ***** Neighbor offsets ******
    // ? x x x --- -1,-1, -1,0, -1,1
    // ? x o x ---  0,-1,        0,1
    // ? x x x ---  1,-1,  1,0,  1,1
    // *****************************

    var count: i8 = 0;


    for ([-1, 0, 1]) |dx| {
        for ([-1, 0, 1]) |dy| {
            if (dx == 0 and dy == 0) continue; // Skip Self

            const nx: usize = coords.x + @as(usize, dx);
            const ny: usize = coords.y + @as(usize, dy);

            if (nx < grid_h and ny < grid_w) {
                if (grid[nx][ny] == 1) {
                    return true;
                }
            }
        }
    }
    return false;
}

pub fn main() !void {}

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
