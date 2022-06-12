from nbresult import ChallengeResultTestCase


class TestMergedDataframes(ChallengeResultTestCase):
    def test_merged_df_has_the_right_shape(self):
        self.assertEqual(self.result.merged_df_shape, (9, 2))

    def test_yearly_oil_value_2009(self):
        self.assertEqual(self.result.yearly_oil_2009, 64180)
