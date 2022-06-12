from nbresult import ChallengeResultTestCase


class TestOil(ChallengeResultTestCase):
    def test_df_has_the_right_shape(self):
        self.assertEqual(self.result.filtered_oil_shape, (9, 35))

    def test_df_has_the_right_index(self):
        self.assertEqual(self.result.filtered_oil_index_year, 2009)

    def test_df_has_the_right_values(self):
        self.assertEqual(self.result.us_total, 64180)
