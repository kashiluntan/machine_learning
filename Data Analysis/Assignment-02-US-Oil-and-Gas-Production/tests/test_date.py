from nbresult import ChallengeResultTestCase


class TestDate(ChallengeResultTestCase):
    def test_month_column_is_a_datetime(self):
        self.assertEqual(self.result.month_type, 'datetime64[ns]')
