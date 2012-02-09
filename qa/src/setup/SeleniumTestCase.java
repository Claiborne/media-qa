package setup;

import com.thoughtworks.selenium.Selenium;
import org.testng.Assert;
import org.testng.Reporter;
import org.testng.annotations.DataProvider;

import java.util.Properties;


/**
 * Created by IntelliJ IDEA.
 * User: Dave
 * Date: 10/20/11
 * Time: 2:37 PM
 * To change this template use File | Settings | File Templates.
 */
public class SeleniumTestCase {


    public Selenium selenium;

    public void waitMs(int howLongInMs) {
        try {
            Thread.sleep(howLongInMs);
        } catch (InterruptedException e) {
            Assert.fail("Thread wait interruption", e);

        }
    }

    /**
     * Waits for an element to exist
     *
     * @param sel                A Selenium object
     * @param elementDescription a Selenium-compatible element description
     * @param totalWaitTimeMs    a long integer value for how long to wait for the object to appear
     */
    public void waitForElementPresent(Selenium sel, String elementDescription, long totalWaitTimeMs){
        int pollTime = 500;

        for (int ms = 0; ; ms += pollTime) {
            if (ms >= totalWaitTimeMs) {
                Reporter.log("Test has failed, location of failure is: " + selenium.getLocation());


                if (selenium.isElementPresent("//div[.='No data found']"))
                {
                    Reporter.log("No Data Found Error");
                }

                Assert.fail("Timeout, waited " + ms + " ms for the '" + elementDescription + "' object to appear");
            }

            try {
                if (sel.isElementPresent(elementDescription)) break;
            } catch (Exception e) {
                Assert.fail("sel.isElementPresent(...) threw an exception while waiting for " + elementDescription, e);
            }

            waitMs(pollTime);
        }
    }


    /**
     * Waits 30sec for an object to appear
     *
     * @param sel                A Selenium object
     * @param elementDescription a Selenium-compatible element description
     */
    public void waitForElementPresent(Selenium sel, String elementDescription) {

//        Properties p = System.getProperties();
//        String os = p.getProperty("browser");

//        if (os.compareTo("iehta")==0 || os.compareTo("iexplore")==0){
//           waitForElementPresent(sel, elementDescription, 5000);
//        }
//        else{
            waitForElementPresent(sel, elementDescription, 30000);
        //}
    }

    public void waitForElementNotPresent(Selenium sel, String elementDescription){

        try {
            waitForElementPresent(sel, elementDescription, 20000);
            Assert.fail("Element was found when it was not suppose to be");
        } catch(Exception e){
            Reporter.log("Element was not found");

        }

    }

}
