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

type PlanetNode = { [planet: string]: number }

const calcOrbits = (edge: 'SAN' | 'YOU', orbits: Orbits): PlanetNode[] => {
  let nodes = []
  let curr: string = edge
  let n = 0
  while (curr !== 'COM') {
    n += 1
    curr = orbits[curr]
    nodes[curr] = n
  }
  return nodes
}

const run = () => {
  const orbits = parse(input)

  const sanNodes = calcOrbits('SAN', orbits)
  const youNodes = calcOrbits('YOU', orbits)
  const intersection = Object.keys(sanNodes).filter(
    p => youNodes[p] !== undefined,
  )
  const distances = intersection.map(p => sanNodes[p] + youNodes[p])
  const minDistance = Math.min(...distances)
  console.log('minDistance', minDistance - 2) // remove 2 it should not count steps between YOU and SANTA
}

run()
