import { input } from './10-input'

type Point = { x: number; y: number }

const flatten = <T>(arr: T[][]): T[] =>
  arr.reduce((acc, curr) => [...acc, ...curr])

const parse = (str: string): Point[] => {
  const rows = str.split('\n')
  const parsed = rows.map((r, y) => {
    const points = r.split('')
    return points
      .map((c, x) => ({ c, x, y }))
      .filter(({ c }) => c === '#')
      .map(({ x, y }) => ({ x, y }))
  })
  return flatten(parsed)
}

const getVector = (a: Point, b: Point): Point => {
  return { x: b.x - a.x, y: b.y - a.y }
}

const getCommonDenominator = (x: number, y: number): number => {
  x = Math.abs(x)
  y = Math.abs(y)
  while (y) {
    const t = y
    y = x % y
    x = t
  }
  return x
}

const normalise = (v: Point) => {
  const gcd = getCommonDenominator(v.x, v.y)
  return { x: v.x / gcd, y: v.y / gcd }
}

const getVisibleAsteroids = (a: Point, all: Point[]): number => {
  const vectors = all.filter(b => b !== a).map(b => getVector(a, b))
  const normalised = vectors.map(v => normalise(v))
  const strings = normalised.map(v => `${v.x},${v.y}`)
  return new Set(strings).size
}

const run = () => {
  const asteroids = parse(input)

  const asteroidsWithNbrVisible = asteroids.map(a => {
    const visible = getVisibleAsteroids(a, asteroids)
    return { a, visible }
  })

  const sorted = asteroidsWithNbrVisible.sort((a, b) => b.visible - a.visible)
  const result = sorted[0]
  console.log('result', result)
}

run()
