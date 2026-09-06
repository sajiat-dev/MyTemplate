from playwright.sync_api import Page, expect


def test_home_page_loads(page: Page):
    response = page.goto("http://127.0.0.1:5000/")

    assert response is not None
    assert response.ok

    expect(page).to_have_url("http://127.0.0.1:5000/")