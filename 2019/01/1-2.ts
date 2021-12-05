// solution for day 1, part 1 will end up here

import { input } from './1-input'
//const input = [100756]

const calcFuel = (mass: number): number => {
  return Math.floor(mass / 3) - 2
}

const calcFuelForFuel = (mass: number): number => {
  const fuel = calcFuel(mass)
  return fuel <= 0 ? 0 : fuel + calcFuelForFuel(fuel)
}

const totalFuel = input
  .map(m => calcFuel(m))
  .map(f => f + calcFuelForFuel(f))
  .reduce((acc, f) => acc + f, 0)

console.log('totalFuel', totalFuel)
