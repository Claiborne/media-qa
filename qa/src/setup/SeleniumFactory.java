package setup;

import com.thoughtworks.selenium.DefaultSelenium;
import org.testng.Assert;


import java.io.FileInputStream;
import java.io.IOException;

import java.util.Properties;

/**
 *
 *
 * Created by IntelliJ IDEA.
 * User: Dave
 * Date: 9/5/11
 * Time: 2:21 PM
 * To change this template use File | Settings | File Templates.
 */
public class SeleniumFactory extends DefaultSelenium{

    String speed = "";

    public SeleniumFactory(String serverHost, int serverPort, String browserStartCommand, String browserURL) {
        super(serverHost, serverPort, browserStartCommand, browserURL);

        Properties properties = new Properties();
        String os = System.getProperty("os.name");
        String env = System.getProperty("env");

        if (os.compareTo("Linux")==0) {
            try {
                //go to any arbitrary location (chose CT_HOMEPAGE) and choose which properties file will be used
                properties.load(new FileInputStream("/var/lib/jenkins/jobs/CT_HomePage/workspace/properties/" + env +".properties"));
                speed= properties.get("speed").toString();

            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        else{
            try {
                properties.load(new FileInputStream("properties/" + env +".properties"));
                speed= properties.get("speed").toString();

            } catch (IOException e) {
                e.printStackTrace();
            }
        }

        super.setSpeed(speed);
    }

    public void waitMs(int howLongInMs) {
        try {
            Thread.sleep(howLongInMs);
        } catch (InterruptedException e) {
            Assert.fail("Thread wait interruption", e);

        }
    }


    @Override
    public void click(String target) {
        try {
            super.setSpeed("200");
            for (int i=0;i<3;i++){
                super.highlight(target);

            }
            super.setSpeed(speed);
            super.click(target);

        } catch (Exception e) {

            e.printStackTrace();
        }
    }

    @Override
    public void type(String target, String value){
        try{
            super.setSpeed("200");
            for (int i=0;i<3;i++){
                super.highlight(target);

            }
            super.setSpeed(speed);
            super.type(target,value);
        } catch (Exception e) {

            e.printStackTrace();
        }
    }

    @Override
    public boolean isElementPresent(String target){
        try{
            super.setSpeed("200");
            for (int i=0;i<3;i++){
                super.highlight(target);

            }
            super.setSpeed(speed);

        } catch (Exception e) {
            return super.isElementPresent(target);
        }

        return super.isElementPresent(target);
    }


    public void goBackRetry(){

        for (int i = 0; i< 10; i++){
            String location = super.getLocation();
            super.goBack();
            waitMs(5000);

            String location2 = super.getLocation();
            if(location.compareTo(location2)!=0){

                break;
            }
            if(i==9 && location.compareTo(location2)==0){
                Assert.fail("Cannot go back to previous screen");
            }
        }

    }







}
