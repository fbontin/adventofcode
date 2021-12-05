import { input } from './8-input'

const width = 25
const height = 6

const splitIntoLayers = (pixelsStr: string): string[] => {
  const regex = new RegExp('.{1,' + width * height + '}', 'g')
  return pixelsStr.match(regex)
}

// 0 is black, 1 is white, 2 is transparent
const stackLayerPixels = (pixels: string[]): string =>
  pixels.reduce((prev, curr) => {
    return prev === '0' || prev === '1' ? prev : curr
  }, '2')

const getSamePixelFromAllLayers = (i: number, layers: string[]): string[] =>
  layers.map(l => l.substr(i, 1))

const getImageString = (layers: string[]): string => {
  let imageString = ''
  for (let i = 0; i < layers[0].length; i++) {
    const pixels = getSamePixelFromAllLayers(i, layers)
    imageString += stackLayerPixels(pixels)
  }
  return imageString
}

const splitToRows = (imageString: string): string => {
  let image = ''
  for (let i = 0; i < imageString.length; i += width) {
    image += imageString.substr(i, width) + '\n'
  }
  return image
}

const prettyPrint = (image: string): void => {
  console.log(image.replace(/0/g, ' ').replace(/1/g, 'X'))
}

const run = () => {
  const layers = splitIntoLayers(input)
  const imageString = getImageString(layers)
  console.log('image', imageString)
  const image = splitToRows(imageString)
  prettyPrint(image)
}

run()
