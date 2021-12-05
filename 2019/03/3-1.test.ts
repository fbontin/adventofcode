import { test } from './3-1'

describe('getIntersectionPoint', () => {
  const { getIntersectionPoint } = test
  ;[
    {
      l1: { start: { x: 0, y: 0 }, end: { x: 5, y: 0 } },
      l2: { start: { x: 2, y: -2 }, end: { x: 2, y: 2 } },
      expected: { x: 2, y: 0 },
    },
    {
      l1: { start: { x: 0, y: 0 }, end: { x: 0, y: 5 } },
      l2: { start: { x: -2, y: 2 }, end: { x: 2, y: 2 } },
      expected: { x: 0, y: 2 },
    },
    {
      l1: { start: { x: 0, y: 0 }, end: { x: 5, y: 0 } },
      l2: { start: { x: 0, y: 0 }, end: { x: 5, y: 0 } },
      expected: null,
    },
  ].forEach(({ l1, l2, expected }) => {
    it('should', () => {
      const result = getIntersectionPoint(l1, l2)
      expect(result).toEqual(expected)
    })
  })
})
