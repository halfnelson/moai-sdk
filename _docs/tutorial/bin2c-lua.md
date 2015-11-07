---
title: "Bin2c.lua"
---

This code turns a Lua source file into a C file that can be included where you would otherwise load it using `luaL_loadfile()`.

It is take verbatim [from the Lua Wiki](http://lua-users.org/cgi-bin/wiki.pl?action=edit&id=BinToCee) with the addition of an `extern "C"` declaration to make it compatible with C++.

Please disregard the buggy syntax highlighting of the Wiki, the script is syntactically correct.

```lua
-- bin2c.lua
local description = [=[
Usage: lua bin2c.lua [+]filename [status]

Write a C source file to standard output.  When this C source file is
included in another C source file, it has the effect of loading and
running the specified file at that point in the program.

The file named by 'filename' contains either Lua byte code or Lua source.
Its contents are used to generate the C output.  If given, 'status' names
a C variable used to store the return value of either luaL_loadbuffer()
or lua_pcall().  Otherwise, the return values of these functions will be
unavailable.

This program is (overly) careful to generate output identical to the
output generated by bin2c5.1 from LuaBinaries.

http://lua-users.org/wiki/BinTwoCee

Original author: Mark Edgar
Licensed under the same terms as Lua (MIT license).
]=]

if not arg or not arg[1] then
  io.stderr:write(description)
  return
end

local compile, filename = arg[1]:match"^(+?)(.*)"
local status = arg[2]

local content = assert(io.open(filename,"rb")):read"*a"

local function boilerplate(fmt)
  return string.format(fmt,
    status and "("..status.."=" or "",
    filename,
    status and ")" or "",
    status and status.."=" or "",
    filename)
end

local dump do
  local numtab={}; for i=0,255 do numtab[string.char(i)]=("%3d,"):format(i) end
  function dump(str)
    return (str:gsub(".", numtab):gsub(("."):rep(80), "%0\n"))
  end
end

io.write(boilerplate[=[
/* code automatically generated by bin2c -- DO NOT EDIT */
#include <moaicore/MOAISim.h>
extern "C" {
/* #include'ing this file in a C program is equivalent to calling
  if (%sluaL_loadfile(L,%q)%s==0) %slua_pcall(L, 0, 0, 0); 
*/
/* %s */

    static const unsigned char B1[]={
]=], dump(content), boilerplate[=[

    };

    MOAISim::RunBuffer ((const char*)B1,sizeof(B1),%q);
}
]=])
```

### Example:

Suppose that this is `hello.lua`

```lua
print "Hello"
```

then

```
lua bin2c.lua hello.lua
```

gives C code:

```c
/* code automatically generated by bin2c -- DO NOT EDIT */
#include <moaicore/MOAISim.h>
extern "C" {
/* #include'ing this file in a C program is equivalent to calling
    if (luaL_loadfile(L,"hello.lua")==0) lua_call(L, 0, 0); 
*/
/* hello.lua */
    static const unsigned char B1[]={
112,114,105,110,116, 32, 34, 72,101,108,108,111, 34,
    };
    MOAISim::RunBuffer ((const char*)B1,sizeof(B1),"hello.lua")==0);
}
```

