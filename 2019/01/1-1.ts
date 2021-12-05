// solution for day 1, part 1 will end up here

import { input } from './1-input'

const calcFuel = (mass: number): number => {
  return Math.floor(mass / 3) - 2
}

const result = input.map(m => calcFuel(m)).reduce((acc, f) => acc + f, 0)

console.log('result', result)
