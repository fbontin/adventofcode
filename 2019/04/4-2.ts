import { start, end } from './4-input'

const hasDoubleDigit = (pw: string): boolean => {
  const regex = /(\d)\1+/gm
  const matches = pw.match(regex)
  if (!matches) return false
  return matches.filter(m => m.length === 2).length > 0
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
  console.log('length', correctOnes.length)
}

run()
