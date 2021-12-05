import { start, end } from './4-input'

const hasDoubleDigit = (pw: string): boolean => {
  const chars = pw.split('')
  return chars.reduce((hasDD, curr, i) => {
    return curr === chars[i + 1] ? true : hasDD
  }, false)
}

const decreases = (pw: string): boolean => {
  const chars = pw.split('')
  const hasDecrease = chars.reduce((dec, curr, i) => {
    const next = chars[i + 1]
    if (next === undefined) return dec
    return next < curr ? true : dec
  }, false)
  return hasDecrease
}

const checkPassword = (pw: string): boolean =>
  hasDoubleDigit(pw) && !decreases(pw)

const run = () => {
  const correctOnes = []
  for (let i = start + 1; i < end; i++) {
    const pw = `${i}`
    if (checkPassword(pw)) correctOnes.push(pw)
  }
  console.log('correctOnes', correctOnes)
  console.log('correctOnes', correctOnes[correctOnes.length - 1])
  console.log('length', correctOnes.length)
}

run()
