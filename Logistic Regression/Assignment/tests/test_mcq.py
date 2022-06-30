from nbresult import ChallengeResultTestCase


class TestMcq(ChallengeResultTestCase):
    def test_mcq(self):
        student_ans = sorted(self.result.mcq.upper())
        correct_ans = ['C']
        self.assertEqual(student_ans, correct_ans)

