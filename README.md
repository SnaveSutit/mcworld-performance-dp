# Performance Tool
A Data Pack for all your performance testing needs!

# Requirements
You must have these installed for the scripts to function properly.
- [7zip](https://www.7-zip.org/)
- [Node.js](https://docs.npmjs.com/downloading-and-installing-node-js-and-npm)
- [yarn](https://classic.yarnpkg.com/lang/en/docs/install) or [npm](https://docs.npmjs.com/downloading-and-installing-node-js-and-npm)
- [MC-Build](https://mcbuild.dev/docs/)

# Connecting the Repo to your Minecraft Client
- Run `yarn install` to install dependancies.
- Then setup the repo with `yarn setup`.

# Creating a Test
- Fork this repo and create a new branch called `test-<test-name>` eg. `test-entity-relation-vs-macros`.
- Open this repo in your favorite IDE, and run `yarn dev:datapack` to start MC-Build.
- Modify `tests.mc` to include your test.
- Open the world in Minecraft and run `/reload` to reload the Data Pack.
- Then click the button on the bottom command block to run the test.
- You can optionally test each of the tests a single time with the command chains on the left and right (Tests A and B respectively).
