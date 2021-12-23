# Gravity Wars

*Gravity Wars* is an [artillery game](https://en.wikipedia.org/wiki/Artillery_game) like [_Scorched Earth_](https://en.wikipedia.org/wiki/Scorched_Earth_(video_game)) or [_Worms_](https://en.wikipedia.org/wiki/Worms_(series)) but with many planets affecting the path of the projectile.

![gravitywars](https://user-images.githubusercontent.com/17264277/87047616-be62fe00-c1c8-11ea-9395-70a5d344923c.png)

## Background

_Gravity Wars_ is not my original idea. In 2007 I played a 1992 MAC version of this game with my friend and thought it was fun. From my brief correspondence with the creator (Rhys Hollow) of the version for Macintosh I learned the original game was written for Amiga (and not by him). In 2009 I learned how to code to create a clone of the game: https://yboris.dev/gravitywars

In 2015 I tried to re-create the game for the iPad using [Codea](https://codea.io/) but lost interest. I finally got around to sharing my code for it in [2019](https://codea.io/talk/discussion/9563/gravity-wars-giving-away-my-code-on-unfinished-game).

In 2020 a co-worker shared [LÖVE](https://love2d.org/) (aka _Love2D_) which, like Codea, uses the *Lua* programming language. I decided to port over my code to _LÖVE_ so as to share this fun game with more people.

The initial commit code is a very quick and dirty port of my 2015 prototype code, which in turn is a quick and dirty port of my 2009 self-taught code. In subsequent commits I improved the code somewhat, but I wouldn't say the current codebase is a good example of how to code well.

## Development

1. Install [LÖVE](https://love2d.org/) (game confirmed to work with v11.3)
2. In your terminal run `love .`

## License

Please feel free to use this code (in full or in part) however you'd like, under the permissive _MIT_ license.

Thank you to Manchson for the _MIT_ licensed [`basis33.ttf`](https://github.com/Manchson/basis33) font.
