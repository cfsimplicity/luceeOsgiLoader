# OSGi bundle installer/loader for Lucee

A simple tool for installing OSGi bundles dynamically in [Lucee Server](https://lucee.org/) (NB: version 5+ only)

## About
This CFML component allows java libraries that have been packaged as OSGi bundles to be easily installed dynamically in Lucee 5+, avoiding the need to manually deploy them in your Lucee server before they can be used.

You can use it to load a class directly from a given local bundle without worrying about whether the bundle has been installed.

## Usage
### Prepare the bundle
 1. Ensure the jar you wish to load has been created as an OSGi bundle. At a minimum this will mean its META-INF/MANIFEST.MF contains `Bundle-SymbolicName` and `Bundle-Version` entries. Use the [`manifestRead()`](https://docs.lucee.org/reference/functions/manifestread.html) Lucee function to check. You will need these two values when installing or loading classes from the bundle.
 2. The jar/bundle can be placed wherever you like in your application (no need for it to go in the Lucee `/lib` directory) as long as its path is accessible to Lucee.

### Load a class using `CreateObject()`
Lucee's  `CreateObject()`allows you to call classes from specific bundles. Use `osgiLoader` to ensure the bundle has been installed. A good place to do this would be in your Application.cfc's `onApplicationStart()` event:
```
//Application.cfc
void function onApplicationStart(){
 var bundleSymbolicName = "com.cflint.CFLint";
 var bundleVersion = "1.4.0";
 var bundlePath = ExpandPath( "/path/to/CFLint.jar" );
 osgiLoader = New osgiLoader();
 if( !osgiLoader.bundleIsLoaded( bundleSymbolicName, bundleVersion ) )
  osgiLoader.installBundle( bundlePath );
}
```
You are then free to load classes from the bundle wherever you like in your application.
```
//myscript.cfm
bundleSymbolicName = "com.cflint.CFLint";
bundleVersion = "1.4.0";
className = "com.cflint.CFLint.CFLintAPI";
apiObject = CreateObject( "java", className , bundleSymbolicName , bundleVersion  );
```
### Load a class using `loadClass()`
Alternatively you can let `osgiLoader` handle the check by using its`loadClass()` method:
```
bundleSymbolicName = "com.cflint.CFLint";
bundleVersion = "1.4.0";
bundlePath = ExpandPath( "/path/to/CFLint.jar" );
className = "com.cflint.CFLint.CFLintAPI";
osgiLoader = New osgiLoader();
apiObject = osgiLoader.loadClass( className, bundlePath, bundleSymbolicName, bundleVersion );
```
This single call will install the bundle if necessary before returning the requested object. (There is negligible overhead in performing the installation check.)

### Uninstalling a bundle
You can also uninstall a bundle that has been dynamically installed:
```
osgiLoader.uninstallBundle( bundleSymbolicName, bundleVersion );
```

## Test Suite
The automated tests require [TestBox 2.1](https://github.com/Ortus-Solutions/TestBox) or later. You will need to create an application mapping for `/testbox`