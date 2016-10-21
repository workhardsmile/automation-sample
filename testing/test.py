#!/usr/bin/python
#-*- coding:utf-8 -*-
from appium import webdriver
import time, os

desired_caps = {}
desired_caps['platformName'] = 'Android'
desired_caps['platformVersion'] = '4.4'
desired_caps['deviceName'] = 'Nexus4API19'
desired_caps['appPackage'] = 'com.istuary.ironhide'
desired_caps['app'] = '/Users/frankwu/testapp/IronHideRelease1.1.1.08.apk'
desired_caps['appActivity'] = '.view.splash.SplashActivity'
 
driver = webdriver.Remote('http://localhost:4733/wd/hub', desired_caps)
 
time.sleep(10)
driver.find_elements_by_class_name('android.widget.RelativeLayout')[0].click()
time.sleep(2)
driver.find_elements_by_class_name('android.widget.LinearLayout')[0].click()
time.sleep(2)
driver.find_element_by_id('com.istuary.ironhide:id/input_phone').send_keys('13540108163')
time.sleep(2)
driver.find_element_by_id('com.istuary.ironhide:id/input_pwd').send_keys('123456')
time.sleep(2)
driver.find_element_by_id('com.istuary.ironhide:id/button').click()
time.sleep(2)

# success = True
# desired_caps = {}
# desired_caps['appium-version'] = '1.0'
# desired_caps['platformName'] = 'Android'
# desired_caps['platformVersion'] = '4.4'
# desired_caps['deviceName'] = 'Nexus4API19'
# desired_caps['app'] = os.path.abspath('/Users/frankwu/testapp/IronHideRelease1.1.1.08.apk')
# desired_caps['appPackage'] = 'com.istuary.ironhide'
# 
# wd = webdriver.Remote('http://127.0.0.1:4724/wd/hub', desired_caps)
# wd.implicitly_wait(60)
# 
# def is_alert_present(wd):
#   try:
#     wd.switch_to_alert().text
#     return True
#   except:
#     return False
# 
# try:
#   wd.find_element_by_xpath("//android.widget.LinearLayout[1]/android.widget.FrameLayout[1]/android.widget.FrameLayout[1]/android.widget.FrameLayout[1]/android.support.v4.widget.DrawerLayout[1]/android.widget.FrameLayout[1]/android.view.View[1]/android.widget.LinearLayout[1]/android.widget.LinearLayout[1]/android.widget.RelativeLayout[1]/android.widget.ImageView[1]").click()
# finally:
#   wd.quit()
#   if not success:
#     raise Exception("Test failed.")
