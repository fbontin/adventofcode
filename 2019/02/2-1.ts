import { input as starterInput } from './2-input'

interface Operation {
  op: number
  one: number
  two: number
  pos: number
}

const splitIntoOps = (code: number[]): Operation[] => {
  const result = []
  code.forEach((n, i) => {
    const chunkIndex = Math.floor(i / 4)
    if (i % 4 === 0) {
      result[chunkIndex] = {
        op: code[i],
        one: code[i + 1],
        two: code[i + 2],
        pos: code[i + 3],
      }
    }
  })
  return result
}

let input = [...starterInput]
input[1] = 12
input[2] = 2

const runOperation = ({ op, one, two, pos }: Operation): boolean => {
  if (op === 99) return true
  if (op === 1) input[pos] = input[one] + input[two]
  if (op === 2) input[pos] = input[one] * input[two]
  return false
}

const runProgram = () => {
  let operations = splitIntoOps(input)
  for (let i = 0; i < operations.length; i++) {
    const operation = operations[i]
    const shouldTerminate = runOperation(operation)
    operations = splitIntoOps(input)
    if (shouldTerminate) return input
  }
}

const finalCode = runProgram()
console.log('finalCode[0]', finalCode[0])
