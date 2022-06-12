from nbresult import ChallengeResultTestCase


class TestFullGas(ChallengeResultTestCase):
    def test_df_has_the_right_shape(self):
        self.assertEqual(self.result.yearly_gas_shape, (11, 19))

    def test_df_has_the_right_index(self):
        self.assertEqual(self.result.index_year, 2008)

    def test_df_has_the_right_values(self):
        self.assertEqual(self.result.us_total, 489473)
