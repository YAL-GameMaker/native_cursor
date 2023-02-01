# native_cursor

Native cursors for GameMaker!

(on Windows. Later HTML5 - have to rewrite everything from scratch)

## What's interesting here

Just a bunch of WinAPI things, really. Made slightly more complex by the fact that I wanted this to be a tiny DLL.

Did you know that if you do
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
