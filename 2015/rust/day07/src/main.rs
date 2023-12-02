use std::collections::HashMap;

#[derive(Debug, Clone)]
enum Signal {
    Number(u16),
    Wire(String),
}

#[derive(Debug, Clone)]
enum Op {
    Signal(Signal),
    And(Signal, Signal),
    Or(Signal, Signal),
    Not(Signal),
    LShift(Signal, u16),
    RShift(Signal, u16),
}

#[derive(Debug, Clone)]
struct Instr {
    input: Op,
    wire: String,
}

fn parse_signal(s: &str) -> Signal {
    match s.parse() {
        Ok(n) => Signal::Number(n),
        Err(_) => Signal::Wire(s.to_string()),
    }
}

fn parse_line(s: &str) -> Instr {
    let words = s.split_whitespace().collect::<Vec<&str>>();
    if words.contains(&"AND") {
        return Instr {
            input: Op::And(parse_signal(words[0]), parse_signal(words[2])),
            wire: words[4].to_string(),
        };
    }
    if words.contains(&"OR") {
        return Instr {
            input: Op::Or(parse_signal(words[0]), parse_signal(words[2])),
            wire: words[4].to_string(),
        };
    }
    if words.contains(&"NOT") {
        return Instr {
            input: Op::Not(parse_signal(words[1])),
            wire: words[3].to_string(),
        };
    }
    if words.contains(&"LSHIFT") {
        return Instr {
            input: Op::LShift(parse_signal(words[0]), words[2].parse().unwrap()),
            wire: words[4].to_string(),
        };
    }
    if words.contains(&"RSHIFT") {
        return Instr {
            input: Op::RShift(parse_signal(words[0]), words[2].parse().unwrap()),
            wire: words[4].to_string(),
        };
    } else {
        return Instr {
            input: Op::Signal(parse_signal(words[0])),
            wire: words[2].to_string(),
        };
    }
}

fn parse_input() -> Vec<Instr> {
    include_str!("../data.txt")
        .lines()
        .map(|l| parse_line(&l))
        .collect()
}

fn run(wire: &str, map: &HashMap<String, Op>, c: &mut HashMap<String, u16>) -> u16 {
    if c.contains_key(wire) {
        return c[wire];
    }
    let op = map.get(wire).unwrap();

    let mut resolve = |signal: &Signal| -> u16 {
        match signal {
            Signal::Wire(name) => run(name, map, c),
            Signal::Number(value) => *value,
        }
    };

    let res = match op {
        Op::Signal(v) => resolve(v),
        Op::Not(v) => !resolve(v),
        Op::LShift(v, x) => resolve(v) << x,
        Op::RShift(v, x) => resolve(v) >> x,
        Op::And(v1, v2) => resolve(v1) & resolve(v2),
        Op::Or(v1, v2) => resolve(v1) | resolve(v2),
    };

    c.insert(wire.into(), res);
    res
}

fn part_1() {
    let instrs = parse_input();
    let mut map = HashMap::new();
    for i in instrs {
        map.insert(i.wire, i.input);
    }
    let mut cache = HashMap::new();
    let res = run(&"a", &map, &mut cache);

    println!("Part 1: {res:?}");
}

fn part_2() {
    let instrs = parse_input();
    let mut map = HashMap::new();
    for i in instrs {
        map.insert(i.wire, i.input);
    }
    let mut cache = HashMap::new();
    cache.insert("b".to_string(), 956);
    let res = run(&"a", &map, &mut cache);

    println!("Part 2: {res:?}");
}

fn main() {
    part_1();
    part_2();
}
