from nbresult import ChallengeResultTestCase
import numpy as np


class TestNumpy(ChallengeResultTestCase):
    def test_vectors_creation(self):
        self.assertEqual(self.result.ten.tolist(), np.zeros(10).tolist())
        self.assertEqual(self.result.from_five.tolist(),
                         np.arange(5, 11).tolist())

    def test_ndarrays_creation(self):
        self.assertEqual(self.result.A.tolist(),
                         np.array([[5, 9, 7], [1, 0, 3]]).tolist())
        self.assertEqual(self.result.B.tolist(),
                         np.ones((2, 2), dtype=int).tolist())

    def test_linear_twenty_vector_creation(self):
        self.assertEqual(self.result.lin_twenty.tolist(),
                         np.linspace(-1, 1, 20).tolist())

    def test_matrixes_creation_and_reshaping(self):
        self.assertEqual(self.result.C.tolist(),
                         np.eye(3, dtype='int').tolist())
        D = np.array([2, 9, 7, 3, 1, 5])
        self.assertEqual(self.result.E.tolist(), D.reshape(2, 3).tolist())
        checkboard = np.tile(np.array([[1, 0], [0, 1]]), (4, 4))
        self.assertEqual(self.result.F.tolist(), checkboard.tolist())

    def test_advanced_matrixes_manipulation(self):
        self.assertEqual(self.result.reshaped_G.shape, (4, 1))
        H = np.array([0, 4, -4, -3, 1, 1]).reshape(3, 2)
        I = np.array([[0, 1], [1, -1], [2, 3]])
        self.assertEqual(self.result.hi_sum.tolist(), (H + I).tolist())
