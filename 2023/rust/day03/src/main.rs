use regex::{Match, Regex};
use std::collections::HashSet;

type Position = (isize, isize);
type Number = (usize, Vec<(isize, isize)>);

fn parse_input() -> impl Iterator<Item = (usize, usize, char)> {
    include_str!("../data.txt")
        .lines()
        .enumerate()
        .flat_map(|(y, l)| l.chars().enumerate().map(move |(x, c)| (x, y, c)))
}

fn is_symbol_char(c: &char) -> bool {
    match c {
        '.' | '0' | '1' | '2' | '3' | '4' | '5' | '6' | '7' | '8' | '9' => false,
        _ => true,
    }
}

fn get_symbols() -> HashSet<Position> {
    parse_input()
        .filter(|(_, _, c)| is_symbol_char(c))
        .map(|(x, y, _)| (x as isize, y as isize))
        .collect()
}

fn get_capture(m: Match, y: usize) -> Number {
    let n = m.as_str().parse::<usize>().unwrap();
    let positions = (m.start()..m.end())
        .map(|x| (x as isize, y as isize))
        .collect();

    (n, positions)
}

fn get_numbers_for_line(y: usize, l: &str) -> Vec<Number> {
    let re = Regex::new(r"\d+").unwrap();
    re.find_iter(l).map(move |mo| get_capture(mo, y)).collect()
}

fn get_numbers() -> Vec<Number> {
    include_str!("../data.txt")
        .lines()
        .enumerate()
        .flat_map(|(y, l)| get_numbers_for_line(y, l))
        .collect()
}

fn get_adjacent_positions((x, y): &Position) -> Vec<Position> {
    [
        (*x - 1, *y - 1),
        (*x, *y - 1),
        (*x + 1, *y - 1),
        (*x - 1, *y),
        (*x + 1, *y),
        (*x - 1, *y + 1),
        (*x, *y + 1),
        (*x + 1, *y + 1),
    ]
    .to_vec()
}

fn is_part_number((_n, positions): &Number, symbols: &HashSet<Position>) -> bool {
    positions
        .iter()
        .flat_map(get_adjacent_positions)
        .any(|p| symbols.contains(&p))
}

fn part_1() {
    let symbols = get_symbols();
    let numbers = get_numbers();

    let res = numbers
        .iter()
        .filter(|n| is_part_number(n, &symbols))
        .map(|(n, _)| *n)
        .sum::<usize>();

    println!("Part 1: {res:?}");
}

fn get_gear_number(gear: &Position, numbers: &Vec<Number>) -> usize {
    let adjacent_numbers: Vec<&Number> = numbers
        .iter()
        .filter(|(_n, pos)| {
            let pos_set: HashSet<Position> =
                HashSet::from_iter(pos.iter().flat_map(get_adjacent_positions));
            pos_set.contains(gear)
        })
        .collect();

    match adjacent_numbers[..] {
        [(n1, _), (n2, _)] => n1 * n2,
        _ => 0,
    }
}

fn part_2() {
    let symbols = get_symbols();
    let numbers = get_numbers();
    let res: usize = symbols.iter().map(|s| get_gear_number(s, &numbers)).sum();

    println!("Part 2: {res:?}");
}

fn main() {
    part_1();
    part_2();
}
