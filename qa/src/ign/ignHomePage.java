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
    @Parameters
    public void login(){

        waitForElementPresent(selenium, "//div");


    }
    
}
