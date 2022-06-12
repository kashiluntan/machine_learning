from nbresult import ChallengeResultTestCase

class TestFilteredGas(ChallengeResultTestCase):
    def test_yearly_gas_production_df_has_the_right_shape(self):
        self.assertEqual(self.result.yearly_gas, (9, 19))
