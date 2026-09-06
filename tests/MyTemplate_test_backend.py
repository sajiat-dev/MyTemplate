def test_login_page_contains_login_form(testapp):
    """Verify that the login page renders the expected form."""
    response = testapp.get("/login")

    assert response.status_code == 200
    assert b"<form" in response.data
    assert b"password" in response.data.lower()