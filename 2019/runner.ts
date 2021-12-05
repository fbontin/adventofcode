const day = process.argv[2]
const paddedDay = day.length === 1 ? `0${day}` : day
const part = process.argv[3]

console.log('day', day)
console.log('part', part)

const runFile = async () => {
  const path = `./${paddedDay}/${day}-${part}`
  console.log('running: ', path)
  await import(path)
}

runFile()
