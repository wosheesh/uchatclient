
What is it?
===========
Uchat is a simple iOS chat app written in Swift. It was build as my final project for the [Udacity iOS Developer nanodegree](https://www.udacity.com/nanodegree). 

Uchat is a basic chat for Udacity students. It allows anyone with an Udacity login to meet with others and discuss topics related to their studies, projects etc. Udacity has a great discussion system already, but I felt like there's a need for more collaboration between students. Afterall, programming is usually done in teams, not individually. I thought that Uchat could be a great exploration of this idea in my final project.

Basic functionality
===================

Users need Udacity credentials to login. After authenticating they can select a chat channel to join from a list that corresponds to the courses they are enrolled in at Udacity. There's also a General channel available to all.

After entering a channel user can send messages to other participants, not unline in IRC. Messages are stored in the app's database to be viewed later.

### Ideas for next features

 - The app could be easily extended to include a list of currently logged in users. Parse already has that information.
 - A delete functionality for erasing chat history
 - "typing" indicator... the app uses APNs which may be too coarse for this kind of information, so it would require changing the message push protocol.
 - create your own chat room... not very difficult to do at this stage.
 - search the chat

Getting Started
===============
In order to get this app working you will need to first jump over couple of hurdles:

1. Set up a standalone [Parse server](https://github.com/ParsePlatform/parse-server) (for push notifications only)
2. Obtain the Apple SSL certificate for your copy of the app and the provisioning profile for your devices. There is a tutorial [here](https://github.com/ParsePlatform/PushTutorial/tree/master/iOS).

Uchat uses the Parse server for push notifications. I have deployed my own standalone server on Heroku, following a guide on [medium.com](https://medium.com/@timothy_whiting/setting-up-your-own-parse-server-568ee921333a#.33qq3k3hx). If you are an Udacity student please contact me if you'd like to use my server for tests.

Once you have the certificates and the server setup you can proceed with the installation.

Installation
============
### Download repository

`git clone https://github.com/wosheesh/uchatclient`

Parse SDK is already added to the repo in *Supporting Files/Frameworks* directory.

### Setup environmental variables for Parse
You need to specify your PARSE_APP_ID, PARSE_SERVER, PARSE_CLIENT_KEY **and** PARSE_MASTER_KEY. This can be done in `ParseConstants.swift`:

    struct Environment {
        static let PARSE_APP_ID: String = envDict["PARSE_APP_ID"]!
        static let PARSE_MASTER_KEY: String = envDict["PARSE_MASTER_KEY"]!
        static let PARSE_SERVER: String = envDict["PARSE_SERVER"]!
        static let PARSE_CLIENT_KEY: String = envDict["PARSE_CLIENT_KEY"]!
    }

You can change the above to your settings or set the actual variables by [editing the Xcode scheme](http://nshipster.com/launch-arguments-and-environment-variables/).
> Uchat **requires your Parse's server master key** in order to enable client-push. Distributing an app with a master key is not generally recommended. More on "dangers" of client push [here](http://blog.parse.com/learn/engineering/the-dangerous-world-of-client-push/).

Comments on the code
====================
Please see COMMENTARY.md for a longer discussion about the code itself.


Known Issues
============
 - The textView controller in ChatViewController doesn't always gets its height properly
 - Channel titles and subtitles may need more space in their cells
 - If noone is chatting, the heroku server stays idle and takes few seconds to activate, resulting in slower first message propagation

Licensing
=========
Read LICENSE

Contact
=======
You can find me on [twitter](https://twitter.com/wmaterka)

Author
======
Wojtek Materka: [www.materka.me](http://www.materka.me)
