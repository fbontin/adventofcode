use std::collections::HashSet;

#[derive(Hash, Eq, PartialEq, Debug, Copy, Clone)]
struct Point {
    x: i32,
    y: i32,
}

fn part_1() {
    let mut current = Point { x: 0, y: 0 };
    let mut houses = HashSet::new();
    houses.insert(Point { x: 0, y: 0 });

    for d in include_str!("../data.txt").chars() {
        current = match d {
            '<' => Point {
                x: current.x - 1,
                ..current
            },
            '^' => Point {
                y: current.y + 1,
                ..current
            },
            '>' => Point {
                x: current.x + 1,
                ..current
            },
            'v' => Point {
                y: current.y - 1,
                ..current
            },
            a => panic!("Not implemented for {a:?}"),
        };
        houses.insert(current);
    }
    let size = houses.len();

    println!("Part 1: {size:?}");
}

fn main() {
    part_1();
}

