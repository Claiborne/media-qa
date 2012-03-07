package ign;

import org.testng.Reporter;
import org.testng.annotations.AfterClass;
import org.testng.annotations.BeforeClass;
import org.testng.annotations.Parameters;
import setup.SeleniumFactory;
import setup.SeleniumSetup;
import setup.SeleniumTestCase;

import java.io.FileNotFoundException;
import java.net.MalformedURLException;
import java.util.Properties;

/**
 * Created by IntelliJ IDEA.
 * User: dortiz
 * Date: 2/2/12
 * Time: 1:11 PM
 * To change this template use File | Settings | File Templates.
 */
public class ignBaseClass extends SeleniumTestCase{

    SeleniumFactory selenium;

    @BeforeClass(alwaysRun = true)
    @Parameters({"URL", "path"})
    public void setup(String url, String path) throws MalformedURLException, FileNotFoundException {


        SeleniumSetup SS = new SeleniumSetup();
        SS.setup(url);

        selenium = new SeleniumFactory(SS.theServer,SS.thePort,SS.theBrowser,SS.theURL);
        selenium.start();
        selenium.useXpathLibrary("javascript-xpath");
        selenium.windowMaximize();

        String commandLinePath = System.getProperty("path");
        if (commandLinePath == null || commandLinePath.compareTo("")==0){
            selenium.open(path);
        }
        else
        {
            selenium.open(commandLinePath);
        }


    }

    @AfterClass(alwaysRun = true)
    public void tearDown() {
        if (selenium != null) {

            Reporter.log("Tearing Down Selenium", true);
            selenium.stop();
            selenium = null;
        }
    }

}
