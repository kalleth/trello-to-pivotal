# trello-to-pivotal

Take all cards from a column named in a certain way (at the moment containing "Sprint +1") on a given trello board, and, if they have a certain label ("Ready for Planning"), add them to a CSV formatted for import into a Pivotal Tracker board.

## Generate trello API keys

1. Visit https://trello.com/app-key and copy your `key`. This is your `TRELLO_API_KEY`.
2. Visit `http://trello.com/1/authorize?key=<TRELLO_API_KEY>&response_type=token&name=trello-to-pivotal&expiration=never&scope=read,write`
3. Click 'Allow'
4. Copy the long alphanumeric string (member token) you see on the subsequent page.

## Quickstart

This is aimed at a developer audience; if you're not a developer, maybe get a dev to pair while you do this.

1. Install `Xcode` from the App Store -- it's free.
2. Open a terminal
3. Enable the command-line tools by typing `xcode-select --install`
4. Install `direnv` -- following the instructions here: https://github.com/direnv/direnv
5. Get the board code of the trello board -- if the URL to the board is `https://trello.com/b/abCDe1/your-special-board` then the board code is `abCDe1`.
6. Create a `.envrc` file in the app root containing the following:
```
export TRELLO_API_KEY=<KEY YOU OBTAINED EARLIER>
export TRELLO_TOKEN=<TOKEN YOU GOT EARLIER WHEN YOU AUTHORISED THE APP>
export TRELLO_BOARD=<TRELLO BOARD CODE>
```
7. `direnv allow`
8. Install bundler; `gem install bundler` (or `sudo gem install bundler` if you're using the default OSX ruby)
9. `bundle install`

## Running the script

`./entire_column_to_pivotal.rb > output.csv`, this will create a new file called `output.csv` which you can import into trello with the entire contents of a matching column.
