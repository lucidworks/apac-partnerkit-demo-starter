Welcome to App Studio
=====================

We believe creating search applications shouldn't be overwhelming, so we created App Studio to help you build modern, user-friendly search apps quickly and simply.

Getting Started
===============

With App Studio you can build a mobile-ready search application in a matter of minutes. Follow the steps below to get up and running.

Full documentation for App Studio Enterprise can be found at https://doc.lucidworks.com

Development tools
-----------------

In building out a search application, we recommend the use of the following tools:

* Java 1.8 JDK
* NodeJS & npm for front-end dependency management
* An IDE (Intellij, VS Code, etc..)

Connecting to Fusion
--------------------

To connect to Fusion, we just need to edit a few config files. We've added some scripts to update these for you, which on Mac or Linux, you can start with the command: ```scripts/set_initial_config.sh``` or on windows: ```scripts\set_initial_config.bat```.

Alternatively, fire up your favourite text editor! All the config files can be found within `src/main/resources/conf`.

Edit `services/api/fusion.conf` - this file controls which Fusion server to use:
- Set the value of `host` to be the hostname of your Fusion server, e.g. `host: localhost` or `host: fusion.example.com`
- Set the value of `port` to be the port of your Fusion server - this is `6764` by default, which is preconfigured for you.

Edit `platforms/fusion/data.conf` - this file configures which data in Fusion to use: 
- Replace the text `YOUR_QUERY_PROFILE` with the name of the Fusion Query Profile you wish to direct your queries through. If you have created an app via the Fusion UI called `MyAwesomeApp`, then you will have a default Query Profile called `MyAwesomeApp` as well - this is a good starting point: e.g. `query-profile: MyAwesomeApp`.

Edit `platforms/fusion/social.conf` - this file configures the Lucidworks Appkit Social Module:
- Replace the text `YOUR_FUSION_APP` with the name of your Fusion app, as used above: e.g. `collection: YOUR_FUSION_APP_user_prefs` becomes `collection: MyAwesomeApp_user_prefs`. This configures the Appkit SDK to store social data in the `_user_prefs` sidecar collection associated with `MyAwesomeApp`. 

Edit `platforms/fusion/suggestions.conf` - this file configures search suggestions:
- Replace the text `YOUR_QUERY_PROFILE` with the name of the Fusion Query Profile you wish to direct your search suggestion queries through. This can be the same Query Profile as you are using for search queries, e.g. `query-profile: MyAwesomeApp`.

Edit `message/service/fusion.conf` - this file configures how Signals are sent to Fusion:
- Replace the text `YOUR_QUERY_PROFILE` with the name of your query profile, as used above: e.g. `query-profile: MyAwesomeApp`.


Starting and Stopping
--------------------------------

### Linux, Mac OS X

To start the application, run the following command from a terminal:

- `./app-studio start`

To stop the application, run the following command from a terminal:

- `./app-studio stop`

To package the application into a WAR file, run the following command from a terminal:

- `./app-studio package`

### Windows

To start the application, run the following command from a command prompt:

- `app-studio.bat start`

To stop the application, run the following command from a Powershell command prompt:

- `app-studio.bat stop`

To package the application into a WAR file, run the following command from a command prompt:

- `app-studio.bat package`

NOTE: See [below](#additional-script-commands) for more commands.

Accessing App Studio
--------------------

Once started, the application is served up at `http://localhost:8080`. You will be asked to authenticate, for which you can use any of your Fusion "native realm" users - if you're just getting started with Fusion, this will be your Fusion `admin` username and password.
 
When building an application for production environments the security realm can be configured in the `src/main/resources/conf/security/fusion.conf` file.

Using Your Data
---------------

The file `src/main/webapp/views/search.html` defines the main page layout of your application. App Studio Enterprise is pre-configured to work out of the box with Lucidworks Fusion, but you may wish to customise which fields you use in your results.

Let's get started!

### Result title

The title of each result document can be configured like so:

Find the tag that looks like this:

```
<search:field name="title_s" styling="title" urlfield="id"></search:field>
```

- `styling="title"` means that it will be used as the result title - no need to change this, but it will help you find the right tag!
- `name="title_s"` configures the application to use the value of the `title_s` field as the displayed title text for each result. If your document titles are stored in a different field, replace `title_s` with the name of that field.
- `urlfield="id"` configures the application to use the value of the `id` field as the hyperlink - when users click on the title, they will be navigated to whatever URL is in the `id` field for that result. If your document URLs are stored in a different field, replace `id` with the name of that field.

### Result description

The text description of each result document can be configured like so:

Find the tag that looks like this:

```
<search:field name="description_s" label="Description" max-characters="240" show-more></search:field>
```

- `label="Description"` will help you find the right tag.
- `name="description_s"` configures the application to use the value of the `description_s` field for the description text of each search result. If your descriptions are stored in a different field, replace `id` with the name of that field.

### Facets

Facets are a handy way to refine your search. By default, App Studio Enterprise will attempt to show facets for the `keywords_s` field, if it exists. We can add or remove facets very simply:

Find the tag that looks like this:

```
<search:query var="query" parameters="*" results-per-page="12" facets="keywords_s"></search:query>
```

This tag creates the overall page query - `facets="keywords_s"` adds the ability to facet on the `keywords_s` field to the query. We can remove this, or add some more facets - this parameter takes a comma-separated list of field names.

Try `facets="keywords_s,charSet_s"`, or replace the value entirely with a list of your own facet fields.


### Activating your changes

To see your changes in action:
- Save the file
- Refresh your browser
- Yes, that's all!

Development
-----------

### Resources

App Studio Enterprise is preconfigured to automatically reload when you make changes to your code during development.

The following file types are monitored and re-processed when changed:
- HTML (`*.html`)
- JavaScript (`*.js`)
- LESS (`*.less`)
- CSS (`*.css`)
- JSP (`*.jsp`)
- Config (`*.conf`)

There will be a slight pause between saving the file and being able to view the changes as App Studio Enterprise processes the file. 
Refresh your browser after about 2 seconds to see the changes.

### Java

Hot reloading of Java class files requires some extra steps. The Java Virtual Machine supports hot-swapping of class files as long as the changes
aren't structural - changes to method bodies and field values are supported, but adding or renaming methods are not.
You will need to use an IDE to set this up - the following steps assume you are using JetBrains IntelliJ IDEA:

1. Import the project into IntelliJ
2. Add a new Maven "Run Configuration" - from the "Run" menu, select "Edit Configurations". Click the "+" button, and select "Maven" from the dropdown.
3. Enter a name for your configuration - e.g. "Jetty Run"
4. Enter the following for the "Command Line": `clean jetty:run -Pdevelopment --settings ./bin/settings.xml -Dtwigkit.conf.watch=true`, then click "Ok".
5. Make sure that you are not already running App Studio Enterprise.
6. From the "Run" menu, click "Debug 'Jetty Run'". If you have named your configuration something other than 'Jetty Run', look for "Debug '<your configuration name here>'"
7. As App Studio Enterprise starts, you will see the console output within your IDE

We're now set up to hot reload Java files:

1. Edit a Java file
2. Save the file
3. From the "Build" menu, select "Recompile <your class name>.java"
4. You will see a popup notifying you that a class file has changed, and asking if you would like to reload classes - click "Yes".
5. Your Java change has been deployed into the running Java Virtual Machine - you can now test your running App Studio Enterprise webapp and see your change in action.

License
-------

App Studio Enterprise comes with a 30-day trial license in `app-studio.lic`. Once this expires, contact Lucidworks for a new license: https://lucidworks.com/company/contact/


## Additional script commands ##


NOTE: Each command and flag is also applicable to the batch script on windows.
### start

###### ./app-studio start [-f] [-p port] [-P profile] [-m memory] [-t timeout] [-V]

`-f` Start App Studio in foreground.

`-p <port>` Specify the port to start the App Studio web server on; default is 8080.

`-P <profile>`  Specify the Appkit profile to use when App Studio starts; defaults to development.

`-m <memory>`   Sets the min (-Xms) and max (-Xmx) heap size for the JVM, such as: -m 4g results in: -Xms4g -Xmx4g; by default, this script sets the heap size to 512m.

`-t <timeout>`  Sets the startup timeout in seconds (defaults to 240).

`-V`            Verbose messages from the startup script.


### stop

###### ./app-studio stop [-p port] [-V]

`-p <port>`   Specify the port the App Studio HTTP listener is bound to.

### package

###### ./app-studio package [-P profile]

`-P <profile>`  Specify the Appkit profile to use when App Studio is packaged; defaults to development.

NOTE: This command will build a new JAR and WAR file with App Studio and place it in `./dist`.
  
### docker

###### ./app-studio docker [package] [start] [-P profile] [-i image_name]

`package`           Package App Studio Enterprise then build a Docker image.

`start`             Package App Studio Enterprise, build a Docker image, then run a container on port 8080.

`-P <profile>`      Specify the Appkit profile to use when App Studio Enterprise is packaged; defaults to development.

`-i <image_name>`  Specify the image name to use when App Studio Enterprise is built as a Docker image; defaults to app-studio-enterprise. The image will be tagged as the latest.


Advanced Configuration
======================

Build Profiles
---------------

To configure an application for different environments, the resources to be deployed to a particular environment are stored in src/main/profiles/<environment> in the source code tree.

To package an application with a particular build profile, the <environment> name is given with the `-P` flag. For example, to deploy to the dev environment you would use the following command:

```./app-studio package -P dev```

Prior to packaging, the contents of the build profile directory are merged with the resources under the main resources directory, overwriting any existing files, and including any additional files.

After the application has been packaged, the war and jar files associated with that particular application profile will be stored under the application’s dist/<environment> directory.


Running the app over SSL
------------------------

The webapp can also be served over HTTPS using SSL encryption. This is done using the following parameters when invoking the startup scripts:

- `-Dtwigkit.ssl=true` required to turn on secure mode

We include a keystore file with a default self-signed key for development / testing of secure mode. However in order to establish proper trust you will need to import your own valid SSL certificate into the file `keystore.jks` or create your own keystore file. You can then configure SSL via:

- `-Dtwigkit.https.port` optionally sets the HTTPS port (defaults to 8765)
- `-Dtwigkit.http.port` optionally sets the HTTP port (defaults to 8080)
- `-Dtwigkit.keystore.file` keystore filename / location relative to webapp (defaults to 'keystore.jks')
- `-Dtwigkit.keystore.password` password to the keystore (defaults to 'p4ssw0rd')
- `-Dtwigkit.keystore.alias` name of the key in the keystore to be used (defaults to 'default-key')

Twigcrypt value encryption utility
------------------------

A best practice that we advocate is to encrypt any sensitive configuration values using our Twigcrypt utility. Twigcrypt's function is to allow you to quickly encrypt sensitive string values using the command line.  These files can be found at `/bin/twigcrypt.zip`.

For more details on how to use Twigcrypt, refer to the README inside the zip file.