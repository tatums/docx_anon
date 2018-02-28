## Sanitizers
Background: An docx document is a zip file with multiple xml files inside.

There are currently 3 Sanitizers
* [app](./app.rb)
* [comments](comments.rb)
* [core](core.rb)

If you'd like to write additional sanitizers you can, by adhering to the sanitizer interface.

1) Your sanitizer must be class method that returns string/buffer that responds to `call` like as a Proc

2) You must define a `FILE_HANDLER` constant inside the class. This tells the main clean method which xml file your sanitizer will be doing work on.
