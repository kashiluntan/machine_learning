from nbresult import ChallengeResultTestCase
import numpy as np


class TestFeatures(ChallengeResultTestCase):
    def test_X_shape(self):
        self.assertEqual(self.result.features.shape, (4, 4))

    def test_x0_is_ones(self):
        self.assertTrue(
            np.array_equal(self.result.features[:, 0], np.ones((4,))),
            'Make sure x0 is the first column of the features.'
        )

    def test_features_order(self):
        self.assertTrue(
            np.array_equal(
                np.max(self.result.features, axis=0),
                np.array([1, 3280, 4, 3])
            ),
            '''Make sure `surface` is the second, `bedrooms` the third and
            `floors` the fourth column of the features.'''
        )
