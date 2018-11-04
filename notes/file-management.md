# Introduction
Throughout the application there are some simple file operations occurring. This document outlines these operations and also suggests ways in which the code can or has been improved.

# SUB filer(switch%)
Our main code relating to file management is the filer subroutine.

The switch parameter is an integer with the following possible values:
- 1

# filex
Besides filer, the other main code section is under a line label (filex).  In general this calls filer, but in one instance it write to cws.cfg.

# EXEIcon
Towards the beginning of the code we have a command to compile the QB64 executable with the named icon.

# mtn.vga
The mountains in the game are a separate graphic and these are loaded using BLOAD.

# cwsicon.vga
The capital icon in the game is a separate graphic and loaded using BLOAD.

# cities.grd
This file consists of one comma separated line per city. This is called early in the code. It could be moved into its own subroutine.

# cws.his
This file keeps a record of game events if history has been abled, it also is first referenced early in the code.

# SUB scribe
Scribe is used to write history to cws.his.

# SUB report(who)
If the history is enabled, a portion of this sub will read from it (cws.his).

# SUB maxx
This subroutine handles the high score leaderboard after the game ends. It reads and writes hiscore.cws.