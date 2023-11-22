fn read_data() -> String {
    include_str!("../data.txt").to_string()
}

fn part_1() {
    let result = read_data()
        .trim()
        .chars()
        .map(|c| match c { '(' => 1, _ => -1 })
        .reduce(|a, b| a + b)
        .unwrap();
    
    println!("Part 1: {result:?}");
}

fn part_2() {
    let mut level = 0;

    for (i, c) in read_data().trim().chars().enumerate() {
        level = level + match c { '(' => 1, _ => -1 };
        if level == -1 {
            let pos = i + 1;
            println!("Part 2: {pos:?}");
                break;
            }
    }
}

fn main() {
    part_1();
    part_2();
}
