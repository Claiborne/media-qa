package ign;

import org.testng.annotations.Parameters;
import org.testng.annotations.Test;

/**
 * Created by IntelliJ IDEA.
 * User: dortiz
 * Date: 2/2/12
 * Time: 1:11 PM
 * To change this template use File | Settings | File Templates.
 */
public class ignHomePage extends ignBaseClass{
    
    
    @Test
    @Parameters({"email", "password", "message"})
    public void login(String email, String password, String message){

        waitForElementPresent(selenium, "//a[.='Sign in']");
        selenium.click("//a[.='Sign in']");

        waitForElementPresent(selenium, "//input[@id='email']");
        selenium.type("//input[@id='email']", email);
        selenium.type("//input[@id='password']", password);
        selenium.click("//input[@value='SIGN IN']");

        waitForElementPresent(selenium,"//form[@id='QuickReply']");
        selenium.type("//textarea[@id='ctrl_message']", message);
        selenium.click("//input[@class='button primary']");

        waitForElementPresent(selenium, "//li[contains(@class, 'message')]//blockquote[contains(.,'"+message+"')]");

        //selenium.runScript("InlineMessageEditor.setData('hello');");
        //String cookie = selenium.getCookie();
        //waitForElementPresent(selenium, "//div");

    }
    
}
