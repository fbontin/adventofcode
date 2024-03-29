use std::cmp;

fn parse_ints(s: String) -> [i32; 3] {
    let dims: Vec<i32> = s.split("x").map(|v| v.parse::<i32>().unwrap()).collect();
    match dims[..] {
        [s1, s2, s3] => [s1, s2, s3],
        _ => panic!("Unpexted number of dimensions"),
    }
}

fn calc_wrapping_paper(s: String) -> i32 {
    let [l, w, h] = parse_ints(s);
    let lw = l * w;
    let wh = w * h;
    let hl = h * l;
    let min = cmp::min(cmp::min(lw, wh), hl);

    2 * lw + 2 * wh + 2 * hl + min
}

fn part_1() {
    let result = include_str!("../data.txt")
        .lines()
        .map(|s| calc_wrapping_paper(String::from(s)))
        .reduce(|a, b| a + b)
        .unwrap();

    println!("Part 1: {result:?}");
}

fn calc_ribbon(s: String) -> i32 {
    let mut dims = parse_ints(s);
    dims.sort();
    let [d1, d2, d3] = dims;

    let wrap = d1 * 2 + d2 * 2;
    let ribbon = d1 * d2 * d3;

    wrap + ribbon
}

fn part_2() {
    let result = include_str!("../data.txt")
        .lines()
        .map(|s| calc_ribbon(String::from(s)))
        .reduce(|a, b| a + b)
        .unwrap();

    println!("Part 2: {result:?}");
}

fn main() {
    part_1();
    part_2();
}

