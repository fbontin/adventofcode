import { path1, path2 } from './3-input'

interface Point {
  x: number
  y: number
}

interface Line {
  start: Point
  end: Point
}

interface DirectionVector {
  x: 0 | 1 | -1
  y: 0 | 1 | -1
}

const directionStringToMove = (
  direction: 'R' | 'L' | 'U' | 'D',
): DirectionVector => {
  if (direction === 'R') return { y: 0, x: 1 }
  if (direction === 'L') return { y: 0, x: -1 }
  if (direction === 'U') return { y: 1, x: 0 }
  if (direction === 'D') return { y: -1, x: 0 }
}

const instructionToLine = (instruction: string, start: Point): Line => {
  const direction = instruction.substr(0, 1)
  const length = parseInt(instruction.substr(1))
  // @ts-ignore
  const directionVector = directionStringToMove(direction)
  const end = {
    x: start.x + directionVector.x * length,
    y: start.y + directionVector.y * length,
  }
  return { start, end }
}

const pathToLines = (path: string): Line[] => {
  const instructions = path.split(',')
  const lines = []
  for (let i = 0; i < instructions.length; i++) {
    const instruction = instructions[i]
    const start = i === 0 ? { x: 0, y: 0 } : lines[i - 1].end
    const line = instructionToLine(instruction, start)
    lines.push(line)
  }
  return lines
}

const isBetween = (a: number, b: number, c: number): boolean => {
  return (a <= b && a >= c) || (a <= c && a >= b)
}

const getIntersectionPoint = (l1: Line, l2: Line): Point | null => {
  // l1 vertical, l2 horizontal
  if (l1.start.x === l1.end.x && l2.start.y === l2.end.y) {
    if (
      isBetween(l1.start.x, l2.start.x, l2.end.x) &&
      isBetween(l2.start.y, l1.start.y, l1.end.y)
    ) {
      return { x: l1.start.x, y: l2.start.y }
    }
  }

  // l1 horizontal, l2 vertical
  if (l1.start.y === l1.end.y && l2.start.x === l2.end.x) {
    if (
      isBetween(l1.start.y, l2.start.y, l2.end.y) &&
      isBetween(l2.start.x, l1.start.x, l1.end.x)
    ) {
      return { x: l2.start.x, y: l1.start.y }
    }
  }
  return null
}

const getIntersectionPoints = (
  lines1: Line[],
  lines2: Line[],
): { int: Point; l1Start: Point; l2Start: Point }[] => {
  const points = []
  for (let i = 0; i < lines1.length; i++) {
    for (let j = 0; j < lines2.length; j++) {
      const l1 = lines1[i]
      const l2 = lines2[j]
      const intersection = getIntersectionPoint(l1, l2)
      if (intersection) {
        points.push({ int: intersection, l1Start: l1.start, l2Start: l2.start })
      }
    }
  }
  return points.filter(p => p.int.x !== 0 && p.int.y !== 0)
}

const getLengthOfLines = (lines: Line[]): number => {
  return lines
    .map(l => Math.abs(l.start.x - l.end.x) + Math.abs(l.start.y - l.end.y))
    .reduce((sum, l) => sum + l, 0)
}

const getLengthUpToIntersection = (
  intPoint: Point,
  pointBeforeInt: Point,
  lines: Line[],
): number => {
  const linesUntilInt = []
  for (let i = 0; i < lines.length; i++) {
    const l = lines[i]
    if (l.start === pointBeforeInt) break
    linesUntilInt.push(l)
  }
  const lastLine = linesUntilInt[linesUntilInt.length - 1]
  return getLengthOfLines(
    linesUntilInt.concat({ start: lastLine.end, end: intPoint }),
  )
}

const getSumLength = (
  intPoint: Point,
  l1pointBeforeInt: Point,
  l2pointBeforeInt: Point,
  lines1: Line[],
  lines2: Line[],
): number => {
  const l1Length = getLengthUpToIntersection(intPoint, l1pointBeforeInt, lines1)
  const l2Length = getLengthUpToIntersection(intPoint, l2pointBeforeInt, lines2)
  return l1Length + l2Length
}

const run = () => {
  const lines1 = pathToLines(path1)
  const lines2 = pathToLines(path2)

  const intersectionPoints = getIntersectionPoints(lines1, lines2)
  const lengths = intersectionPoints.map(ip =>
    getSumLength(ip.int, ip.l1Start, ip.l2Start, lines1, lines2),
  )
  const shortestLength = Math.min(...lengths)
  console.log('shortestLength', shortestLength)
}

run()
