import { input } from './8-input'

const width = 25
const height = 6

const splitIntoLayers = (pixelsStr: string): string[] => {
  const regex = new RegExp('.{1,' + width * height + '}', 'g')
  return pixelsStr.match(regex)
}

const getCount = (digit: number, l: string): number => {
  const matches = l.match(new RegExp(digit + '', 'g'))
  return matches ? matches.length : 0
}

const getLayerWithFewestZeroes = (layers: string[]): string => {
  const layerWithCount = layers.map((l, i) => ({ n: getCount(0, l), l }))
  const fewestZeroesLayer = layerWithCount.sort((l1, l2) => l1.n - l2.n)[0].l
  return fewestZeroesLayer
}

const calc = (l: string): number => getCount(1, l) * getCount(2, l)

const run = () => {
  const layers = splitIntoLayers(input)
  const l = getLayerWithFewestZeroes(layers)
  const result = calc(l)
  console.log('result', result)
}

run()
