use std::collections::HashSet;

use regex::Regex;

#[derive(Debug)]
enum State {
    On,
    Off,
    Toggle,
}

#[derive(Debug, Eq, Hash, PartialEq)]
struct Point(u32, u32);

#[derive(Debug)]
struct Instr {
    state: State,
    from: Point,
    to: Point,
}

fn parse_point(s: &str) -> Point {
    let split: Vec<&str> = s.split(',').collect();

    Point(
        split[0].parse::<u32>().unwrap(),
        split[1].parse::<u32>().unwrap(),
    )
}

fn parse_line(s: &str, re: &Regex) -> Instr {
    let caps = re.captures(s).unwrap();

    Instr {
        state: match caps.get(1).unwrap().as_str() {
            "turn on" => State::On,
            "turn off" => State::Off,
            "toggle" => State::Toggle,
            _ => panic!("Instruction not found"),
        },
        from: parse_point(caps.get(2).unwrap().as_str()),
        to: parse_point(caps.get(3).unwrap().as_str()),
    }
}

fn parse_input() -> Vec<Instr> {
    // Defining regex here once to improve performance
    let re = Regex::new(r"^(\w+\s?\w*) (\d+,\d+) through (\d+,\d+)$").unwrap();

    include_str!("../data.txt")
        .lines()
        .map(|l| parse_line(&l, &re))
        .collect()
}

fn generate_points(p1: Point, p2: Point) -> Vec<Point> {
    (p1.0..=p2.0)
        .flat_map(|x| (p1.1..=p2.1).map(move |y| Point(x, y)))
        .collect()
}

fn run(instructions: Vec<Instr>) -> usize {
    let mut lights: HashSet<Point> = HashSet::new();

    for instr in instructions {
        let points = generate_points(instr.from, instr.to);
        for p in points {
            match instr.state {
                State::On => lights.insert(p),
                State::Off => lights.remove(&p),
                State::Toggle => {
                    if lights.contains(&p) {
                        lights.remove(&p)
                    } else {
                        lights.insert(p)
                    }
                }
            };
        }
    }

    lights.len()
}

fn part_1() {
    let instructions = parse_input();
    let res = run(instructions);

    println!("Part 1: {res:?}");
}

fn main() {
    part_1();
}
