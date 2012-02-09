package setup;

import org.testng.Reporter;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.net.MalformedURLException;
import java.util.Properties;


public class SeleniumSetup {
    public String theBrowser = "";
    public String theServer = "";
    public int thePort = 4444;
    public String theURL = "";

    public SeleniumSetup() {
    }


    public void setup(String connectToUrl) throws MalformedURLException, FileNotFoundException {

        Properties properties = new Properties();

        //Check to see if these were given at the command line
        String env = System.getProperty("env");
        String browser = System.getProperty("browser");
        String os = System.getProperty("os.name");
        String url = System.getProperty("url");
        Reporter.log("os is "+ os);
        String server = "";
        String port = "";
        String speed = "";

        //Check to see if URL is null
        if (connectToUrl == null) {
            throw new NullPointerException("connectToUrl Must Not Be Null");
        }

        //Need to be able to identify if the tests are running on a windows box or a jenkins box so you can read the filepath to the properties file correctly
        if (os.compareTo("Linux")==0){
            try {

                //go to any arbitrary location (chose CT_HOMEPAGE) and choose which properties file will be used

                properties.load(new FileInputStream("/var/lib/jenkins/jobs/CT_HomePage/workspace/properties/" + env +".properties"));

                server = properties.get("server").toString();
                port = properties.get("port").toString();
                speed= properties.get("speed").toString();

                //Check to see if browser was set at the command line, if it was not then use the default browser from the property file
                if (browser == null){
                    browser = properties.getProperty("browser");
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        }

        //not on jenkins
        else{
            try {

                properties.load(new FileInputStream("properties/" + env +".properties"));

                server = properties.get("server").toString();
                Reporter.log("server is (not jenkins)" +server);
                port = properties.get("port").toString();
                speed= properties.get("speed").toString();

                //Check to see if browser was set at the command line, if it was not then use the default browser from the property file
                if (browser == null){
                    browser = properties.getProperty("browser");
                }
            } catch (IOException e) {
                e.printStackTrace();
            }

        }
        Reporter.log("url is "+ url);
        //if the user specifies a url at the commandline then use that url, otherwise it will use the connectToURL passed in from the .xml

        if (os.compareTo("Linux")==0){
            if (!url.isEmpty()){
                connectToUrl = "http://" + url + ".ign.com/";
            }

        }
        else if (url != null && os.compareTo("Linux")!=0){
            if (!url.contains(".com")){
                connectToUrl = "http://" + url + ".ign.com/";
            }
        }
        else if(url==null){
            connectToUrl = "http://ign.com";
        }

        Reporter.log("connect to url is "+ connectToUrl);
        Reporter.log("server is " + server);
        Reporter.log("browser is "+ browser);

        theBrowser = browser;
        theServer = server;
        thePort = Integer.parseInt(port);
        theURL = connectToUrl;

//        Selenium s = new DefaultSelenium(server,Integer.parseInt(port),browser,connectToUrl);
//        s.setSpeed(speed);
//
//        return s;
    }




}
