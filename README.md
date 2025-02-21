### Blade Playground

A simple and fun playground for tinkering and playing around with the Blade Programming Language

---

The Blade Playground is a web service that runs on bladelang.org's servers. The service receives a Blade program and runs the program inside a sandboxed runtime, then returns the output.

There are limitations to the programs that can be run in the playground.

The playground can use most of the standard library, with some exceptions:

- The only communication a playground program has to the outside world is by writing to standard output, and standard error.
- The playground uses a virtual filesystem and does not impact any physical machine. For these reason, files are not store across multiple runs.
- The `io`, `os`, and `socket` module are emulated and for this reason, the playground version migth be a few days behind the official version of this modules. Nearly all the input functions from the `io` module will simply return an autogenerated value.
- The playground restricts executing commands via `os.exec` and will only return the reponse `Executed` irrespective of whatever command a user runs.
- The program restricts the `socket` module ability to bind, accept, and listen and this in turn affects the `http` server module. Also, the socket timeouts cannot be overriden in the playground as all network connections have a total timeout of 5 seconds.
- The program restricts thread creation to a maximum of 10 per playground.

The playground uses the latest stable release of Blade.

The playground service is officially hosted at [play.bladelang.org](https://play.bladelang.org/) but can be hosted anywhere by anybody (in fact, we encourage this as this will help reduce load on the official version). All we ask is that you contact let us know (by raising an issue) so that we can list your project as part of the available playgrounds, and that your service is of benefit to the entire Blade community.

> **IMPORTANT**
>
> While we trust every member of our community, remeber that you owe it to everyone to use the 
> playground responsibly. 
> 
> The greatest security is the responsibility of every member of the community.

Any requests for content removal should be directed to [eqliqandfriends@gmail.com](mailto:eqliqandfriends@gmail.com). Please include the URL and the reason for the request.

