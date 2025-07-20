# native_cursor

Native cursors for GameMaker!

**Supported versions:** GM2022+ and GM LTS

**Supported platforms:**

- Windows
- Linux
- HTML5

Could possibly do Mac [like this](https://medium.com/@colleagueriley/rgfw-under-the-hood-mouse-and-window-icons-fb06a3b686ed),
but - isn't that a lot of code for a custom cursor

## What's interesting here

Cursor management on Windows and Linux is _kind of_ similar
so I'm getting away with a bunch of `#ifdef`s.

The code could be shorter, but for now it is what it is.

Some things are there for a reason - for example, did you know that if you do
```cpp
SetCursor(cursor);
DestroyCursor(cursor);
// ... more cleanup code 
SetCursor(NULL);
```
there's a very small chance that the system will access the cursor in the meantime and your application will crash?
Gotta unset the cursors before destroying them.

## Building

See [BUILD.md](BUILD.md)

## Meta

**Author:** [YellowAfterlife](https://github.com/YellowAfterlife)  
**License:** Custom license (see `LICENSE`)
