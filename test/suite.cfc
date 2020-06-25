component extends="testbox.system.BaseSpec"{

	function beforeAll(){
		variables.osgiLoader = New "../osgiLoader"();
		variables.testBundlePath = GetDirectoryFromPath( GetCurrentTemplatePath() ) & "test-osgi.jar";
		variables.testBundleSymbolicName = "test.osgiBundle";
		variables.testBundleVersion = "1.0.0";
	}

	function run( testResults, testBox ){

		describe( "osgiLoader", ()=> {

			afterEach( function(){
				osgiLoader.uninstallBundle( testBundleSymbolicName, testBundleVersion );
			});

			it( "can load a class from a specified bundle, installing it if necessary", ()=> {
				osgiLoader.uninstallBundle( testBundleSymbolicName, testBundleVersion );
				var object = osgiLoader.loadClass( "Basic", testBundlePath, testBundleSymbolicName, testBundleVersion );
				expect( BundleInfo( object ).name ).toBe( testBundleSymbolicName );
			} );

			it( "can install and uninstall a bundle, and detemine if a bundle is loaded or not", () => {
				osgiLoader.installBundle( testBundlePath );
				expect( osgiLoader.bundleIsLoaded( testBundleSymbolicName, testBundleVersion ) ).toBeTrue();
				osgiLoader.uninstallBundle( testBundleSymbolicName, testBundleVersion );
				expect( osgiLoader.bundleIsLoaded( testBundleSymbolicName, testBundleVersion ) ).toBeFalse();
			});
			
		});

	} 

}