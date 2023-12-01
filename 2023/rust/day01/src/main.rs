use regex::Regex;

fn read_data() -> String {
    include_str!("../data.txt").to_string()
}

fn calc_line(s: &str) -> usize {
    let first = s.chars().find(|c| c.to_digit(10).is_some()).unwrap();
    let last = s.chars().rev().find(|c| c.to_digit(10).is_some()).unwrap();

    let mut result = first.to_string();
    result.push(last);

    return result.parse().unwrap();
}

fn part_1() {
    let result = read_data()
        .lines()
        .map(calc_line)
        .reduce(|a, b| a + b)
        .unwrap();

    println!("Part 1: {result:?}");
}

fn parse_number(s: &str) -> usize {
    match s {
        "1" | "one" => 1,
        "2" | "two" => 2,
        "3" | "three" => 3,
        "4" | "four" => 4,
        "5" | "five" => 5,
        "6" | "six" => 6,
        "7" | "seven" => 7,
        "8" | "eight" => 8,
        "9" | "nine" => 9,
        _ => panic!("unknown number"),
    }
}

fn calc_line_2(s: &str) -> usize {
    let re = Regex::new(r"(\d|one|two|three|four|five|six|seven|eight|nine).*(\d|one|two|three|four|five|six|seven|eight|nine)").unwrap();
    let caps = re.captures(s);
    if let Some(c) = caps {
        let first = c.get(1).unwrap().as_str();
        let last = c.get(2).unwrap().as_str();
        parse_number(first) * 10 + parse_number(last)
    } else {
        let re = Regex::new(r"(\d|one|two|three|four|five|six|seven|eight|nine)").unwrap();
        let n = re.captures(s).unwrap().get(1).unwrap().as_str();
        parse_number(n) * 11
    }
}

fn part_2() {
    let result = read_data()
        .lines()
        .map(calc_line_2)
        .reduce(|a, b| a + b)
        .unwrap();

    println!("Part 2: {result:?}");
}

fn main() {
    part_1();
    part_2();
}

