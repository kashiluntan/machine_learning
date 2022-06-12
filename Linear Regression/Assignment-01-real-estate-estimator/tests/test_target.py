from nbresult import ChallengeResultTestCase


class TestTarget(ChallengeResultTestCase):
    def test_shape(self):
        self.assertEqual(self.result.target.shape, (4, 1))
