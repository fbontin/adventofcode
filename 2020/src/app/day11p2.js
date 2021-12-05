const fs = require('fs');

// const data = `L.LL.LL.LL
// LLLLLLL.LL
// L.L.L..L..
// LLLL.LL.LL
// L.LL.LL.LL
// L.LLLLL.LL
// ..L.L.....
// LLLLLLLLLL
// L.LLLLLL.L
// L.LLLLL.LL`;

const data = fs
    .readFileSync('data/11.txt')
    .toString("utf-8");

const parse = () => 
    data.split("\n").map((row) => row.split(""));

const getVisibleSeat = (seats, x, y, d) => {
    const nextX = x + d[0];
    const nextY = y + d[1];
    const s = seats[nextY] && seats[nextY][nextX];
    return s === "." ? getVisibleSeat(seats, nextX, nextY, d) : s;
}

const getVisibleSeats = (seats, x, y) => {
    const directions = [
        [-1, -1], [-1, 0], [-1, 1],
        [ 0, -1],          [ 0, 1],
        [ 1, -1], [ 1, 0], [ 1, 1],
    ];
    return directions.map((d) => getVisibleSeat(seats, x, y, d));
};

const updateSeat = (seats, x, y) => {
    const current = seats[y][x];
    if (current === ".") return ".";

    const nbrOccupied = getVisibleSeats(seats, x, y)
        .filter((s) => s === "#")
        .length;
    if (current === "L") {
        return nbrOccupied === 0 ? "#" : "L"
    };
    return nbrOccupied >= 5 ? "L" : "#";
}

const count = (seats) => {
    return seats
        .reduce((prev, curr) => [...prev, ...curr])
        .filter((s) => s === "#").length;
}

const updateUntilStable = (prevSeats, seats) => {
    if (prevSeats.toString() === seats.toString()) {
        return count(seats);
    } else {
        const newSeats = [...seats.map((row) => [...row])];
        for (let y = 0; y < seats.length; y++) {
            for (let x = 0; x < seats[y].length; x++) {
                newSeats[y][x] = updateSeat(seats, x, y);
            } 
        }
        return updateUntilStable(seats, newSeats);
    }
}

const run = () => {
    const seats = parse();
    const result = updateUntilStable([[]], seats);
    console.log('result', result);
}

run();
