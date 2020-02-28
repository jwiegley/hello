# Greeting the world in many languages

This repository contains simple Hello World programs in various languages that
I use. What is perhaps of more interest is that I've created simple Nix
templates for getting started with these languages. For any one of these
sub-directories, on any machine with Nix installed, you should be able to type
`nix-shell` and then find yourself in a shell environment that makes the
necssary tools available to build and run the program.

The beauty, of course, is that I don't really need to know if you're on Linux,
or macOS, or what other versions of things you have on your machine. It could
take a very long time for `nix-shell` to complete the first time, but once
you're in that shell, I'll have a very clear idea of which version of every
dependency you'll have used to build these examples.
