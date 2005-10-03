--	$Id: stuffit.applescript,v 1.2 2005/02/17 02:22:32 inajima Exp $

(*
 * Copyright (c) 2005 Inajima Daisuke All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 3. The name of the copyright holder may not be used to endorse or
 *    promote products derived from this software without specific prior
 *    written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDER ``AS IS'' AND ANY EXPRESS
 * OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT HOLDER BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 *)

on StuffIt(filenames, format, cflag)
	set quitFlag to true
	tell application "Finder"
		set appList to name of processes
		repeat with obj in appList
			if obj contains "DropStuff" then set quitFlag to false
		end repeat
	end tell
	
	tell application "DropStuff"
		activate
		if format is "X" then
			stuff filenames format StuffItX ignore desktop files cflag
		else
			stuff filenames format StuffIt ignore desktop files cflag
		end if
		if quitFlag is true then quit
	end tell
end StuffIt

on StuffItPOSIX(filenames, format, cflag)
	repeat with i from 1 to count of filenames
		set item i of filenames to item i of filenames as POSIX file
	end repeat
	StuffIt(filenames, format, cflag)
end StuffItPOSIX
