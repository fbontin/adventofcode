use regex::Regex;

fn parse_set_part(re: Regex, s: &str) -> usize {
    re.captures(s)
        .and_then(|c| c.get(1))
        .and_then(|c| Some(c.as_str()))
        .unwrap_or_else(|| "0")
        .parse()
        .unwrap()
}

fn parse_set(s: &str) -> [usize; 3] {
    [
        parse_set_part(Regex::new(r"(\d+) red").unwrap(), s),
        parse_set_part(Regex::new(r"(\d+) green").unwrap(), s),
        parse_set_part(Regex::new(r"(\d+) blue").unwrap(), s),
    ]
}

fn parse_row(s: &str) -> (usize, [usize; 3]) {
    let (id_string, sets_string) = s.split_once(":").unwrap();
    let id = id_string.split_once(" ").unwrap().1.parse().unwrap();
    let sets = sets_string
        .split(";")
        .into_iter()
        .map(parse_set)
        .reduce(|[r0, g0, b0], [r1, g1, b1]| [r0.max(r1), g0.max(g1), b0.max(b1)])
        .unwrap();

    (id, sets)
}

fn part_1() {
    let res = include_str!("../data.txt")
        .lines()
        .map(parse_row)
        .filter(|(_id, [r, g, b])| r <= &12 && g <= &13 && b <= &14)
        .map(|(id, _rgb)| id)
        .reduce(|a, b| a + b)
        .unwrap();

    println!("Part 1: {res:?}");
}

fn part_2() {
    let res = include_str!("../data.txt")
        .lines()
        .map(parse_row)
        .map(|(_id, [r, g, b])| r * g * b)
        .reduce(|a, b| a + b)
        .unwrap();

    println!("Part 2: {res:?}");
}

fn main() {
    part_1();
    part_2();
}
