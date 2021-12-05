import { input } from './6-input'

// key is edge, value is center
interface Orbits {
  [edge: string]: string
}

const parseRow = (inp: string): Orbits => {
  const split = inp.split(')')
  return { [split[1]]: split[0] }
}

const parse = (inp: string): Orbits => {
  const rows = inp.split('\n')
  return rows.map(parseRow).reduce((acc, curr) => ({ ...acc, ...curr }))
}

const calcOrbit = (edge: string, orbits: Orbits): number => {
  let curr = edge
  let n = 0
  while (curr !== 'COM') {
    n += 1
    curr = orbits[curr]
  }
  return n
}

const calcOrbits = (orbits: Orbits): number => {
  const planets = Object.keys(orbits)
  return planets
    .map(p => calcOrbit(p, orbits))
    .reduce((acc, curr) => acc + curr, 0)
}

const run = () => {
  const orbits = parse(input)
  const result = calcOrbits(orbits)
  console.log('result', result)
}

run()
