<cfscript>
paths = [ "root.test.suite" ];
testRunner = New testbox.system.TestBox( paths );
WriteOutput( testRunner.run() );
</cfscript>