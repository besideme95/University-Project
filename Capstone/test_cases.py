
import time
import unittest
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.wait import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.common.exceptions import NoSuchElementException

from selenium.webdriver.support.ui import WebDriverWait


class TestMaybankPortal(unittest.TestCase):
    def setUp(self):
        self.driver = webdriver.Chrome()  
        self.driver.get('https://getq04.qbe.ee/maybank')

    def test_start_button(self):
        wait = WebDriverWait(self.driver, 5)  # Wait for up to 5 seconds
        start_button = wait.until(EC.presence_of_element_located((By.CSS_SELECTOR, ".sc-eqUAAy")))
        start_button.click()
        # Add assertions here to verify the functionality of the Start button
        time.sleep(1)
        self.assertEqual(self.driver.current_url, 'https://getq04.qbe.ee/maybank/c')

    def tearDown(self):
        self.driver.quit()

class TestStates(unittest.TestCase):
    def setUp(self):
        self.driver = webdriver.Chrome()
        self.states = {
            "Johor": ".sc-fPXMVe:nth-child(4) > div",
            "Kedah": ".sc-fPXMVe:nth-child(5) > div",
            "Kelantan": ".sc-fPXMVe:nth-child(6) > div",
            "Melaka": ".sc-fPXMVe:nth-child(7) > div",
            "Negeri Sembilan": ".sc-fPXMVe:nth-child(8) > div",
            "Pahang": ".sc-fPXMVe:nth-child(9) > div",
            "Perak": ".sc-fPXMVe:nth-child(10) > div",
            "Perlis": ".sc-fPXMVe:nth-child(11) > div",
            "Kuala Lumpur": ".sc-fPXMVe:nth-child(12) > div",
            "Terengganu": ".sc-fPXMVe:nth-child(13) > div",
            "Selangor": ".sc-fPXMVe:nth-child(14) > div",
            "Penang": ".sc-fPXMVe:nth-child(15) > div",
            "Putrajaya": ".sc-fPXMVe:nth-child(16) > div"
        }

    def test_state_buttons(self):
        for state, css_selector in self.states.items():
            # Navigate to the main page
            try:
                self.driver.get('https://getq04.qbe.ee/maybank')
                wait = WebDriverWait(self.driver, 5)  # Wait for up to 5 seconds
                start_button = wait.until(EC.presence_of_element_located((By.CSS_SELECTOR, ".sc-eqUAAy")))
                start_button.click()
                # Add assertions here to verify the functionality of the Start button
                # Find the state button and click it
                state_button = WebDriverWait(self.driver, 10).until(EC.element_to_be_clickable((By.CSS_SELECTOR, css_selector)))
                state_button.click()
                time.sleep(1)
                # Check that we have navigated to the next page
                expected_url = 'https://getq04.qbe.ee/maybank/c' if state == 'Selangor' else 'https://getq04.qbe.ee/maybank/b'
                self.assertEqual(self.driver.current_url, expected_url)
                #self.assertEqual(self.driver.current_url, 'https://getq04.qbe.ee/maybank/b')
            except Exception as e:
                print(f"Test failed for state: {state}")
                print(f"Error: {str(e)}")
                pass 


    def tearDown(self):
        self.driver.quit()


if __name__ == "__main__":
    unittest.main()