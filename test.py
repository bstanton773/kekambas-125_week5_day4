import unittest

from whiteboard import solution

class MatchTestCase(unittest.TestCase):
    def test_example_one(self):
        self.assertEqual(solution([]), [])
    def test_example_two(self):
        self.assertEqual(solution(["a","b","c"]), ["1: a", "2: b", "3: c"])
    def test_just_one(self):
        self.assertEqual(solution(["a"]),["1: a"])
    def test_words(self):
        self.assertEqual(solution(["the","quick","brown","fox"]), ["1: the","2: quick","3: brown","4: fox"])
    def test_cool_teachers(self):
        self.assertEqual(solution(["brian","dylan","ryan","sarah","shoha","alex",'brandt']),["1: brian","2: dylan","3: ryan","4: sarah","5: shoha","6: alex",'7: brandt'])


if __name__ == '__main__':
    unittest.main()