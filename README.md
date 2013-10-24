WinOCPHC
========

Windows Offline Common Password Hash Checker

Auto review Windows Password hashes and compare looking for common password, disabled and previous passwords.

Useful when review a Windows domain controller or server, extract the hashes and this will highlight issues.

It will display all users with the same password set (as hash value is the same and not salted) which shows users have common passwords.
It will highlight disabled or previously set passwords (if fgdump/gsecdump used) and flag if a user has the same password as previously set.

This is useful for pen tests as can highlight missing processes within a company, such as the Helpdesk could be creating all new users with the same password, but not forcing a password change at next login.
It also will highlight if the user has been able to set their password to one that was previosuly used. Plus shows they are probably not forcing regular password changes for users.

Often I find many standard domain users have the same password as many domain administrators.

Developed by Daniel Compton

https://github.com/commonexploits/winocphc

Released under AGPL see LICENSE for more information


Installing
========

Windows Offline Common Password Hash Checker

How To Use
========

Windows Offline Common Password Hash Checker


Features
========

Windows Offline Common Password Hash Checker


Screen Shots
========

Windows Offline Common Password Hash Checker


Change Log
========

Windows Offline Common Password Hash Checker

