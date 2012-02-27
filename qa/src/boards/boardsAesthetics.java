package boards;

import org.testng.Reporter;
import org.testng.annotations.Parameters;
import org.testng.annotations.Test;

/**
 * Created by IntelliJ IDEA.
 * User: dortiz
 * Date: 2/27/12
 * Time: 10:29 AM
 * To change this template use File | Settings | File Templates.
 */
public class boardsAesthetics extends boardsBaseClass{

    @Test
    @Parameters({"username", "password", "email"})
    public void login(String username, String password, String email){

        waitForElementPresent(selenium, "//h1[.='IGN Boards']");

        Reporter.log("Clicking 'Sign in'");
        selenium.click("//div[@class='ignHeader-authentication']//a[contains(.,'Sign in')]");
        waitForElementPresent(selenium, "//h1[.='Sign in']");

        Reporter.log("Logging into environment with credtials:" +email +" / " +password);
        selenium.type("//input[@id='email']", email);
        selenium.type("//input[@id='password']", password);

        Reporter.log("Clicking 'SIGN IN'");
        selenium.click("//input[@value='SIGN IN']");

        Reporter.log("Waiting for page to load displaying username at the top right");
        waitForElementPresent(selenium, "//div[@class='userInfo']//div[.='"+username+"']");
    }

    @Test(dependsOnMethods = "login")
    @Parameters({})
    public void verifyBoardsCategories(){

        waitForElementPresent(selenium, "//h1[.='IGN Boards']");

        int numOfCategories = selenium.getXpathCount("//div[@class='categoryText']//a").intValue();
        Reporter.log("There are" + numOfCategories + " board topics");

        Reporter.log("Verifying that clicking on each title goes to the correct boards page");
        for (int i = 1; i < numOfCategories+1; i++){

            String title = selenium.getText("//ol[@id='forums']/li["+i+"]//div[@class='categoryText']//a");
            Reporter.log("Title of category is: "+ title);
            selenium.click("//ol[@id='forums']/li["+i+"]//div[@class='categoryText']//a");
            Reporter.log("Clicking on title");
            waitForElementPresent(selenium, "//h1[.='"+title+"']");
            Reporter.log("Verifying that header contains category title");
            selenium.goBack();
            Reporter.log("Returning to boards main page");
            waitForElementPresent(selenium, "//h1[.='IGN Boards']");

        }
    }
    @Test(dependsOnMethods = "verifyBoardsCategories")
    @Parameters({})
    public void verifyBoardsSubCategories(){

        Reporter.log("Verifying that every sub category links to the correct board");
        int numOfSubCategories = selenium.getXpathCount("//ol[@id='forums']/li[1]//ol/li//div[@class='nodeText']//a").intValue();

        for (int i = 1; i < numOfSubCategories + 1; i++){

            String title = selenium.getText("//ol[@id='forums']/li[1]//ol/li["+i+"]//div[@class='nodeText']//a").replace("...", "");
            Reporter.log("Title of sub-category is:" +title);
            selenium.click("//ol[@id='forums']/li[1]//ol/li["+i+"]//div[@class='nodeText']//a");
            Reporter.log("Clicking on title of subCategory");
            waitForElementPresent(selenium, "//h1[contains(.,\""+title+"\")]");
            Reporter.log("Verifying that the header contains the sub-category title");
            selenium.goBack();
            Reporter.log("Returning to boards main page");
            waitForElementPresent(selenium, "//h1[.='IGN Boards']");

        }

    }

    @Test(dependsOnMethods = "verifyBoardsSubCategories")
    @Parameters({})
    public void verifySubCategoryAesthetics(){

        Reporter.log("Verifying that 'Latest' shows title of the latest post");
        int numOfSubCategories = selenium.getXpathCount("//ol[@id='forums']/li[1]//ol/li//div[@class='nodeText']//a").intValue();

        for (int i = 1; i < numOfSubCategories + 1; i++){

            String title = selenium.getText("//ol[@id='forums']/li[1]//ol/li["+i+"]//div[contains(@class, 'nodeLastPost')]/a").replace("...", "");
            Reporter.log("Title of thread is: "+ title);
            String userName = selenium.getText("//ol[@id='forums']/li[1]//ol/li["+i+"]//div[contains(@class, 'nodeLastPost')]//span/a");
            Reporter.log("username of last post is: "+ userName);
            Reporter.log("Clicking on title of last post");
            selenium.click("//ol[@id='forums']/li[1]//ol/li["+i+"]//div[contains(@class, 'nodeLastPost')]/a");
            Reporter.log("Verifying that title is present in the header");
            waitForElementPresent(selenium, "//h1[contains(.,\""+title+"\")]" );
            int numOfPosts = selenium.getXpathCount("//li[contains(@class, 'message')]").intValue();
            Reporter.log("Verifying that username: "+userName +" made the last post on the thread");
            waitForElementPresent(selenium, "//li[contains(@class, 'message')]["+numOfPosts+"]//div[@class='messageUserBlock']//h3/a[.='"+userName+"']");
            selenium.goBack();
            waitForElementPresent(selenium, "//h1[.='IGN Boards']");

        }
    }

    @Test(dependsOnMethods = "verifySubCategoryAesthetics")
    @Parameters({"username"})
    public void verifyVisitorStatistics(String username){

        Reporter.log("Verifying that the link goes to user profile");
        selenium.click("//div[@class='visitorText']//h2//a[.='"+username+"']");
        waitForElementPresent(selenium, "//h1[.='"+username+"']");
        selenium.goBack();
        waitForElementPresent(selenium, "//div[@class='visitorText']//h2//a[.='"+username+"']");

        Reporter.log("Verifying that clicking on the avatar creates popup with user information");
        selenium.click("//div[@class='section visitorPanel']//a[contains(@class, 'avatar')]");
        waitForElementPresent(selenium, "//div[contains(@id, 'memberCard')]");
        Reporter.log("Verifying membercard stats");
        waitForElementPresent(selenium, "//div[contains(@id, 'memberCard')]//h3[@class='username']//a[.='"+username+"']");
        Reporter.log("User title: "+ selenium.getText("//div[contains(@id, 'memberCard')]//h4[@class='userTitle']"));
        Reporter.log("User blurb: "+ selenium.getText("//div[contains(@id, 'memberCard')]//div[@class='userBlurb']"));

        Reporter.log("Verifying that member stats show correctly");
        waitForElementPresent(selenium, "//dl[contains(@class, 'userStats')]//dt[.='Member Since:']");
        waitForElementPresent(selenium, "//dl[contains(@class, 'userStats')]//dt[.='Messages:']");
        waitForElementPresent(selenium, "//dl[contains(@class, 'userStats')]//dt[.='Likes Received:']");
        waitForElementPresent(selenium, "//dl[contains(@class, 'userStats')]//dt[.='Trophy Points:']");
        waitForElementPresent(selenium, "//dl[contains(@class, 'pairsInline')]//dt[.='"+username+" was last seen:']");
        Reporter.log("Clicking link 'Profile Page'");
        selenium.click("//a[.='Profile Page']");
        waitForElementPresent(selenium, "//h1[.='"+username+"']");
        selenium.goBack();
        waitForElementPresent(selenium, "//h1[.='IGN Boards']");

        Reporter.log("Number of messages:" + selenium.getText("//div[@class='stats']//dl[contains(., 'Messages')]//dd"));
        Reporter.log("Number of likes:" + selenium.getText("//div[@class='stats']//dl[contains(., 'Likes')]//dd"));
        Reporter.log("Number of points:" + selenium.getText("//div[@class='stats']//dl[contains(., 'Points')]//dd"));

    }
    @Test(dependsOnMethods = "verifyVisitorStatistics")
    @Parameters({})
    public void verifyStaffOnlineNow(){

        Reporter.log("Verifying if staff members are online");
        Reporter.log("There are " + selenium.getXpathCount("//div[@class='secondaryContent']//h3[.='Staff Online Now']/..//ul//li") + " staff members online");

    }

    @Test(dependsOnMethods = "verifyStaffOnlineNow")
    @Parameters({})
    public void verifyMembersOnlineNow(){

        Reporter.log("Verifying if members are online");
        Reporter.log("There are " + selenium.getXpathCount("//div[@class='secondaryContent']//h3[.='Members Online Now']/..//ul//li") + " thumbnails showing of people online");
        Reporter.log("There are: " + selenium.getText("//div[@class='footnote']"));

    }

    @Test(dependsOnMethods = "verifyMembersOnlineNow")
    @Parameters({})
    public void verifyForumStatistics(){
        
        Reporter.log("There are "+ selenium.getText("//div[@id='boardStats']//dl[@class='discussionCount']//dd") + " discussions");
        Reporter.log("There are "+ selenium.getText("//div[@id='boardStats']//dl[@class='messageCount']//dd") + " messages");
        Reporter.log("There are "+ selenium.getText("//div[@id='boardStats']//dl[@class='memberCount']//dd") + " members");
        Reporter.log("Latest member "+ selenium.getText("//div[@id='boardStats']//dl[4]//a"));

    }



}
