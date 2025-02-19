### Blade Playground

A simple and fun playground for tinkering and playing around with the Blade Programming Language

---

The Blade Playground is a web service that runs on bladelang.org's servers. The service receives a Blade program and runs the program inside a sandboxed runtime, then returns the output.

There are limitations to the programs that can be run in the playground:

- The playground can use most of the standard library, with some exceptions. The only communication a playground program has to the outside world is by writing to standard output and standard error.
- The playground restricts executing commands via `os.exec` and will only return the reponse `Executed` irrespective of whatever command a user runs.
- The playground restricts working on files and directories outside of the local sandbox running the program.
- The program restricts any network call via the `socket` module and in turn the `http` module and will rather return a generic response that will be automatically selected out of a list of dummy responses.
- The program restricts threads creation to a maximum of 10 per playground.

The playground uses the latest stable release of Blade.

The playground service is officially hosted at [play.bladelang.org](https://play.bladelang.org/) but can be hosted anywhere by anybody (in fact, we encourage this as this will help reduce load on the official version). All we ask is that you contact let us know (by raising an issue) so that we can list your project as part of the available playgrounds, and that your service is of benefit to the entire Blade community.

Any requests for content removal should be directed to [eqliqandfriends@gmail.com](mailto:eqliqandfriends@gmail.com). Please include the URL and the reason for the request.

