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

const getVector = (a: Point, b: Point): Point => ({
  x: b.x - a.x,
  y: b.y - a.y,
})

const getAngle = (a: Point): number => {
  const radians = Math.atan2(a.y, a.x)
  const degreesFromX = (radians * 180) / Math.PI
  const angle = (degreesFromX + 90 + 360) % 360
  return angle
}

const getDistance = (a: Point): number => Math.abs(a.x) + Math.abs(a.y)

const getAsteroids = (a: Point, all: Point[]) => {
  const vectors = all.filter(b => b !== a).map(b => getVector(a, b))
  return vectors.map(v => ({ a: getAngle(v), d: getDistance(v), v }))
}

type Polar = { a: number; d: number; v: Point }

const sortAsteroids = (all: Polar[]): Polar[] => {
  let sorted = all.sort((a, b) => {
    return a.a - b.a || a.d - b.d
  })
  for (let i = 0; i < sorted.length; i++) {
    const curr = sorted[i]
    let next = sorted[i + 1]
    while (curr.a === next?.a) {
      const removed = sorted.splice(i + 1, 1)
      sorted = sorted.concat(removed)
      // ugly solution but hey, it works :-)
      if (next === sorted[i + 1] || next === sorted[i + 2]) break
      next = sorted[i + 1]
    }
  }

  return sorted
}

const getResult = (p: Point): number => p.x * 100 + p.y

const toAbsolute = (a: Point, b: Point): Point => ({
  x: a.x + b.x,
  y: a.y + b.y,
})

const run = () => {
  const asteroids = parse(input)
  const a = { x: 37, y: 25 }
  const polarAsteroids = getAsteroids(a, asteroids)
  const sorted = sortAsteroids(polarAsteroids)
  const result = getResult(toAbsolute(a, sorted[200 - 1]?.v))
  console.log('result', result)
}

run()

export const test = {
  getAngle,
}
