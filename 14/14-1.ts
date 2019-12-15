import { input } from './14-input'

type Chemical = { amount: number; name: string }
type Reaction = { inputs: Chemical[]; result: Chemical }

const parseChemical = (str: string): Chemical => {
  const [amountStr, name] = str.trim().split(' ')
  return { amount: parseInt(amountStr), name }
}

const parseReaction = (str: string): Reaction => {
  const [inpStr, resultStr] = str.split('=>')
  const inputs = inpStr
    .split(',')
    .map(s => s.trim())
    .map(s => parseChemical(s))
  const result = parseChemical(resultStr)
  return { inputs, result }
}

let leftOvers: { [c: string]: number } = {}
let reactions: Reaction[]

const react = (name: string, amount: number): number => {
  const { inputs, result } = reactions.find(r => r.result.name === name)
  const multiplier = Math.ceil(amount / result.amount)

  let ore = 0
  for (const i of inputs) {
    if (i.name === 'ORE') {
      ore += multiplier * i.amount
    } else {
      if (!leftOvers[i.name]) leftOvers[i.name] = 0

      if (leftOvers[i.name] < multiplier * i.amount) {
        ore += react(i.name, multiplier * i.amount - leftOvers[i.name])
      }
      leftOvers[i.name] -= multiplier * i.amount
    }
  }

  if (!leftOvers[result.name]) leftOvers[result.name] = 0
  leftOvers[result.name] += multiplier * result.amount
  return ore
}

export const run = (inp: string = input) => {
  reactions = inp.split('\n').map(parseReaction)
  const ore = react('FUEL', 1)
  leftOvers = {}
  console.log('ore', ore)
  return ore
}

run()
