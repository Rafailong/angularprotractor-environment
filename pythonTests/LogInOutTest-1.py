from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.support.ui import Select
from selenium.common.exceptions import NoSuchElementException
import unittest, time, re

class LogInOutTest(unittest.TestCase):
    def setUp(self):
        self.driver = webdriver.PhantomJS()
        self.driver.implicitly_wait(30)
        self.base_url = "http://docs.seleniumhq.org/"
        self.verificationErrors = []
        self.accept_next_alert = True
    
    def test_log_in_out(self):
        driver = self.driver
        driver.get("http://test.corpfolder.com")
        # ERROR: Caught exception [ERROR: Unsupported command [selectWindow | null | ]]
        driver.find_element_by_css_selector("css=div.header-inner div.right-aligned-buttons.no-margin-right input").click()
        driver.find_element_by_id("login-email").clear()
        driver.find_element_by_id("login-email").send_keys("gzapien+2@nearbpo.com")
        driver.find_element_by_id("login-password").clear()
        driver.find_element_by_id("login-password").send_keys("As121212")
        driver.find_element_by_id("login-password").click()
        driver.find_element_by_name("loginEntrar").click()
        self.assertTrue(self.is_element_present(By.CSS_SELECTOR, ".wp-welcome-title"))
        # ERROR: Caught exception [ERROR: Unsupported command [highlight | css=.wp-welcome-title | ]]
        driver.find_element_by_css_selector("span.logout").click()
    
    def is_element_present(self, how, what):
        try: self.driver.find_element(by=how, value=what)
        except NoSuchElementException, e: return False
        return True
    
    def is_alert_present(self):
        try: self.driver.switch_to_alert()
        except NoAlertPresentException, e: return False
        return True
    
    def close_alert_and_get_its_text(self):
        try:
            alert = self.driver.switch_to_alert()
            alert_text = alert.text
            if self.accept_next_alert:
                alert.accept()
            else:
                alert.dismiss()
            return alert_text
        finally: self.accept_next_alert = True
    
    def tearDown(self):
        self.driver.quit()
        self.assertEqual([], self.verificationErrors)

if __name__ == "__main__":
    unittest.main()
