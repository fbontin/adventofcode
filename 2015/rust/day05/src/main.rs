fn has_no_forbidden_combination(s: &str) -> bool {
    !(s.contains("ab") || s.contains("cd") || s.contains("pq") || s.contains("xy"))
}

fn has_one_letter_twice_in_row(s: &str) -> bool {
    s.as_bytes().windows(2).find(|c| c[0] == c[1]).is_some()
}

fn has_min_three_vowels(s: &str) -> bool {
    s.chars()
        .filter(|c| match c {
            'a' | 'e' | 'i' | 'o' | 'u' => true,
            _ => false,
        })
        .count()
        >= 3
}

fn is_nice_string(s: &str) -> bool {
    has_min_three_vowels(s) && has_one_letter_twice_in_row(s) && has_no_forbidden_combination(s)
}

fn part_1() {
    let count = include_str!("../data.txt")
        .lines()
        .filter(|s| is_nice_string(s))
        .count();

    println!("Part 1: {count:?}");
}

fn has_repeating_char_with_char_between(s: &str) -> bool {
    s.as_bytes().windows(3).find(|c| c[0] == c[2]).is_some()
}

fn has_double_pair(s: &str) -> bool {
    for pair in s.chars().collect::<Vec<char>>().windows(2) {
        if s.split(&pair.into_iter().collect::<String>()).count() >= 3 {
            return true;
        }
    }
    false
}

fn part_2() {
    let count = include_str!("../data.txt")
        .lines()
        .filter(|s| has_double_pair(s) && has_repeating_char_with_char_between(s))
        .count();

    println!("Part 2: {count:?}");
}

fn main() {
    part_1();
    part_2();
}

