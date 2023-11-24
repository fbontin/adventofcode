use std::collections::HashSet;

#[derive(Hash, Eq, PartialEq, Debug, Copy, Clone)]
struct Point {
    x: i32,
    y: i32,
}

fn walk(d: char, p: Point) -> Point {
    match d {
        '<' => Point { x: p.x - 1, ..p },
        '^' => Point { y: p.y + 1, ..p },
        '>' => Point { x: p.x + 1, ..p },
        'v' => Point { y: p.y - 1, ..p },
        a => panic!("Not implemented for {a:?}"),
    }
}

fn part_1() {
    let mut current = Point { x: 0, y: 0 };
    let mut houses = HashSet::new();
    houses.insert(Point { x: 0, y: 0 });

    for d in include_str!("../data.txt").chars() {
        current = walk(d, current);
        houses.insert(current);
    }
    let size = houses.len();

    println!("Part 1: {size:?}");
}

fn part_2() {
    let mut santa = Point { x: 0, y: 0 };
    let mut robo = Point { x: 0, y: 0 };
    let mut houses = HashSet::new();
    houses.insert(Point { x: 0, y: 0 });

    for (i, d) in include_str!("../data.txt").chars().enumerate() {
        if i % 2 == 0 {
            santa = walk(d, santa);
            houses.insert(santa);
        } else {
            robo = walk(d, robo);
            houses.insert(robo);
        }
    }
    let size = houses.len();

    println!("Part 2: {size:?}");
}

fn main() {
    part_1();
    part_2();
}

