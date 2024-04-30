import pytest
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

class TestMaybankPortal:
    def setup_method(self, method):
        self.driver = webdriver.Chrome()
        self.driver.maximize_window()  # Optional: Maximize the browser window
        self.driver.get("https://getq04.qbe.ee/maybank")

    def teardown_method(self, method):
        self.driver.quit()

    def test_start_button_functionality(self):

        wait = WebDriverWait(self.driver, 5)
        start_button = wait.until(EC.element_to_be_clickable((By.CSS_SELECTOR, ".sc-eqUAAy")))
        start_button.click()
        # Simulate clicking the "Start" button
        self.driver.find_element(By.CSS_SELECTOR, ".sc-eqUAAy").click()
        assert self.driver.current_url == "https://getq04.qbe.ee/maybank" 

# Example usage
if __name__ == "__main__":
    pytest.main(["-v", "TC001.py"])  