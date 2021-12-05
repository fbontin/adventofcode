import { test } from './10-2'

describe('getAngle', () => {
  const { getAngle } = test
  ;[
    [{ x: 0, y: -1 }, 0],
    [{ x: 1, y: -1 }, 45],
    [{ x: 1, y: 0 }, 90],
    [{ x: 1, y: 1 }, 135],
  ].forEach(([a, expected]: [{ x: number; y: number }, number]) => {
    it(`${a.x},${a.y} => ${expected}`, () => {
      const result = getAngle(a)
      expect(result).toEqual(expected)
    })
  })
})
