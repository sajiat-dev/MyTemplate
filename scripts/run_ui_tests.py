import os
import subprocess
import sys
import time
import urllib.request

HOST = "127.0.0.1"
PORT = 5000
URL = f"http://{HOST}:{PORT}/"

def wait_for_server(url, timeout=30):
    start = time.time()

    while time.time() - start < timeout:
        try:
            with urllib.request.urlopen(url, timeout=2) as response:
                if response.status < 500:
                    return
        except Exception:
            time.sleep(0.5)

    raise RuntimeError(f"Server did not start within {timeout} seconds")


def main():
    env = os.environ.copy()
    env["APPNAME_ENV"] = "test"

    server = subprocess.Popen(
        [
            sys.executable,
            "-m",
            "flask",
            "--app",
            "manage:app",
            "run",
            "--host",
            HOST,
            "--port",
            str(PORT),
        ],
        env=env,
    )

    try:
        wait_for_server(URL)

        result = subprocess.run(
            [
                sys.executable,
                "-m",
                "pytest",
                "tests/MyTemplate_test_ui.py",
                "-v",
                "--junitxml=artifacts/junit/playwright.xml",
                "--output=artifacts/playwright",
                "--tracing=retain-on-failure",
                "--screenshot=only-on-failure",
            ]
        )

        sys.exit(result.returncode)

    finally:
        server.terminate()
        server.wait()

if __name__ == "__main__":
    main()