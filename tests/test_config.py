from appname import create_app


class TestConfig:
    def test_dev_config(self):
        """ Tests if the development config loads correctly """

        app = create_app('appname.settings.DevConfig')

        assert app.config['DEBUG'] is True
        assert app.config['SQLALCHEMY_DATABASE_URI'] == 'sqlite:///../database.db'
        assert app.config['CACHE_TYPE'] == 'SimpleCache'

    def test_test_config(self):
        """ Tests if the test config loads correctly """

        app = create_app('appname.settings.TestConfig')

        assert app.config['DEBUG'] is True
        assert app.config['CACHE_TYPE'] == 'NullCache'

