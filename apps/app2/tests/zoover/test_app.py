from zoover.flask_app import App
import unittest


class TestApp(unittest.TestCase):
    def test_if_everything_is_fine(self):
        your_app = App()
        self.assertEqual(your_app.app_is_fine(), True)
