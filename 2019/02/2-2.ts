import { input as starterInput } from './2-input'

interface Operation {
  op: number
  one: number
  two: number
  pos: number
}

let input = [...starterInput]

const getOperation = (i: number): Operation => {
  return {
    op: input[i],
    one: input[i + 1],
    two: input[i + 2],
    pos: input[i + 3],
  }
}

const runOperation = ({ op, one, two, pos }: Operation): boolean => {
  if (op === 99) return true
  if (op === 1) input[pos] = input[one] + input[two]
  if (op === 2) input[pos] = input[one] * input[two]
  return false
}

const runProgram = () => {
  for (let i = 0; i < input.length; i += 4) {
    const operation = getOperation(i)
    const shouldTerminate = runOperation(operation)
    if (shouldTerminate) return input
  }
}

const testNounAndVerb = () => {
  for (let noun = 0; noun < 100; noun++) {
    console.log('noun', noun)
    for (let verb = 0; verb < 100; verb++) {
      input[1] = noun
      input[2] = verb // verb
      const finalCode = runProgram()
      if (finalCode[0] === 19690720) {
        return { noun, verb }
      }
      input = [...starterInput]
    }
  }
}

const { noun, verb } = testNounAndVerb()
console.log('noun, verb', noun, verb)
console.log('100 * noun + verb', 100 * noun + verb)
