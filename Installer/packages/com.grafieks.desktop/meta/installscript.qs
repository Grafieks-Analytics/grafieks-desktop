function Component()
{
    // constructor
    component.loaded.connect(this, Component.prototype.loaded);
    if (!installer.addWizardPage(component, "Page", QInstaller.TargetDirectory))
        console.log("Could not add the dynamic page.");

}

Component.prototype.isDefault = function()
{
    // select the component by default
    return true;
}

Component.prototype.createOperations = function()
{
    try {
        // call the base create operations function
        component.createOperations();

        
        var cmd = installer.environmentVariable("SystemRoot") + "\\System32\\cmd.exe";
        
//        var addKey = "HKEY_CLASSES_ROOT\\WOW6432Node\\.gads";
//        var addValue = "HKEY_CLASSES_ROOT\\WOW6432Node\\.gads /ve /t REG_SZ /d \"Grafieks Data Source Live\"";

        
//        component.addElevatedOperation("Execute", cmd, "/C", "add reg", addKey);
//        component.addElevatedOperation("Execute", cmd, "/C", "add reg", addValue);


    } catch (e) {
        console.log(e);
    }
}

Component.prototype.loaded = function ()
{
    var page = gui.pageByObjectName("DynamicPage");
    if (page != null) {
        console.log("Connecting the dynamic page entered signal.");
        page.entered.connect(Component.prototype.dynamicPageEntered);
    }
}

Component.prototype.dynamicPageEntered = function ()
{
    var pageWidget = gui.pageWidgetByObjectName("DynamicPage");
    if (pageWidget != null) {
        console.log("Setting the widgets label text.")
        pageWidget.m_pageLabel.text = "This is a dynamically created page.";
    }
}
